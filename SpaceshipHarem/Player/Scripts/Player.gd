extends Node2D

signal formation_done
signal game_over
signal formation_usable
signal formation_unusable

export(int, 0, 10) var stat_health = 1
export(int, 0, 10) var stat_agility = 1
export(int, 0, 10) var stat_range = 1
export(int, 0, 10) var stat_energy = 1
export(int, 0, 10) var stat_mind = 1

var softness = 0.1
var bias = 0
export var cadence = 0.5
export var inv_time = 1

var max_health
var health
var energy : float = 0
var max_energy = 100
var delta_energy = 0.5
var energy_multi = 1
var damage
var speed
var ships : Array
var chains : Array
var forms : Array
var ship_scene = preload("res://Player/SmallShip.tscn")
var chain_scene = preload("res://Player/Chain.tscn")
var shot_scene = preload("res://Player/Shot.tscn")
var explosion_scene = preload("res://Effects/SmallExplosion.tscn")
var energy_restore_scene = preload("res://Effects/EnergyRestore.tscn")
var shot_spawn_scene = preload("res://Effects/ShotSpawnEffect.tscn")

var is_shooting = true

onready var energy_restore_sound = $EnergyRestoreSound
onready var ship1_forms = $Ship1/Formations
onready var ship2_forms = $Ship2/Formations

var is_in_formation = false

var form_scale = 1 + (Global.current_pilots.size() * 0.1 - 0.5 )

func get_stat(stat, minimum, maximum):
	var s = minimum + stat * (maximum - minimum) / 10 
	return s
	
func _ready():
	$ShotTimer.wait_time = cadence
	
	var nextPosition = $Ship1.position
	
	#Variable of node a
	var lastNode = NodePath($Ship1.get_path())
	
	#Create joint and attach Ship1
	var j = create_joint($Ship1.position, lastNode)
	
	#Create first chain and attach it to joint
	var chain = create_chain(nextPosition)
	chains.append(chain)
	nextPosition = chain.position
	lastNode = NodePath(chain.get_path())
	j.set_node_b(lastNode)
	
	#Calculate next position
	nextPosition = calc_next_position(chain.position, chain)
	
	for i in Global.current_pilots:
		#Create ship and put it at the end of the chain
		var s = ship_scene.instance()
		s.specie = i.specie
		s.main_color = i.color
		add_formation(i.formation)
		
		add_stats_from_ship(i)
		s.position = Vector2(0, chain.get_node("CollisionShape2D").get_shape().height/2)
		get_node(lastNode).add_child(s)
		
		#Add ship to ship list
		ships.append(s)
		
		#Add a joint and attach the last chain to it
		j = create_joint(nextPosition, lastNode)
		
		#Create next chain and attach it to joint
		chain = create_chain(nextPosition)
		chains.append(chain)
		lastNode = NodePath(chain.get_path())
		nextPosition = chain.position
		j.set_node_b(lastNode)
		
		#Calculate next position
		nextPosition = calc_next_position(chain.position, chain)
	
	#Create final joint
	j = create_joint(nextPosition, lastNode)
	
	#Attach ship and last node to joint
	$Ship2.position = nextPosition
	j.set_node_b(NodePath($Ship2.get_path()))
	
	damage = get_stat(stat_range, 1, 3)
	max_health = int(get_stat(stat_health, 5, 15))
	max_energy = int(get_stat(stat_energy, 50, 100))
	speed = get_stat(stat_agility, 300, 600)
	delta_energy = get_stat(stat_mind, 1, 3)
	energy_multi = get_stat(stat_mind, 1, 3)
	
	$Ship1.speed = speed
	$Ship2.speed = speed
	
	health = max_health
	
func add_formation(id):
	if not forms.has(id):
		var f = Global.get_form_by_id(id)
		if f != null:
			var form_node = load(f.scene_path).instance()
			form_node.energy = f.energy_req
			form_node.id = id
			form_node.scale = Vector2(form_scale, form_scale)
			ship1_forms.add_child(form_node)
			var form_node2 = load(f.scene_path).instance()
			form_node2.energy = f.energy_req
			form_node2.id = id
			form_node2.scale = Vector2(form_scale, form_scale)
			ship2_forms.add_child(form_node2)
			forms.append(id)
	
func add_stats_from_ship(s):
	for i in s.stats:
		add_stat(i[1], i[0])
	
func add_stat(stat, amount):
	match stat:
		Global.STAT_NAMES.Damage:
			stat_range = clamp(stat_range + amount, 1, 10)
		Global.STAT_NAMES.MaxEnergy:
			stat_energy = clamp(stat_energy + amount, 1, 10)
		Global.STAT_NAMES.MaxHP:
			stat_health = clamp(stat_health + amount, 1, 10)
		Global.STAT_NAMES.RecoverySpeed:
			stat_mind = clamp(stat_mind + amount, 1, 10)
		Global.STAT_NAMES.Speed:
			stat_agility = clamp(stat_agility + amount, 1, 10)
	
func _physics_process(_delta):
	if collide_with_enemies():
		take_damage(1)
		
	if not is_in_formation: 
		if Input.is_action_pressed("keep_formation"):
			for c in chains:
				c.set_mode(RigidBody2D.MODE_CHARACTER)
		if Input.is_action_just_released("keep_formation"):
			for c in chains:
				c.set_mode(RigidBody2D.MODE_RIGID)
	#Formations logic
	if not is_in_formation:
		#Iterate all formations when button pressed
		for i in ship1_forms.get_children().size():
			var ship = can_use_formation(i)
			if ship > 0:
				emit_signal("formation_usable", ship1_forms.get_children()[i].id)
				if Input.is_action_pressed("activate_formation"):
					do_formation(ship, i)
			else:
				emit_signal("formation_unusable", ship1_forms.get_children()[i].id)
					
func can_use_formation(i):
	if is_formation_done(ship1_forms.get_children()[i]) and ship1_forms.get_children()[i].energy <= energy:
		return 1
	if is_formation_done(ship2_forms.get_children()[i]) and ship2_forms.get_children()[i].energy <= energy:
		return 2
	return 0
					
func do_formation(ship, i):
	is_in_formation = true
	emit_signal("formation_done")
	if ship == 1:
		ship1_forms.get_children()[i].do_effect(form_scale)
	if ship == 2:
		ship2_forms.get_children()[i].do_effect(form_scale)
	#Change the mode of the chains to keep them in place
	for c in chains:
		c.set_mode(RigidBody2D.MODE_CHARACTER)
	energy -= ship1_forms.get_children()[i].energy
			
func _process(delta):
	energy = move_toward(energy, max_energy, delta_energy * delta)
		
		
func collide_with_enemies():
	var bodies = $Ship1.get_colliding_bodies() + $Ship2.get_colliding_bodies()
	for b in bodies:
		if b.get_collision_layer() == 4:
			b.queue_free()
			return true
	return false
		
func take_damage(d):
	#Add damage sound here
	if $InviTimer.get_time_left() <= 0:
		health -= d
		$InviTimer.start(inv_time)
		$Ship1.blink = true
		$Ship2.blink = true
		if health <= 0:
			death_animation()
			
func death_animation():
	add_explosion($Ship1.global_position)
	add_explosion($Ship2.global_position)
	for s in ships:
		add_explosion(s.global_position)
	emit_signal("game_over")
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
	
func add_explosion(pos):
	var e = explosion_scene.instance()
	e.global_position = pos
	get_parent().add_child(e)
			
func charge_energy(e):
	if !energy_restore_sound.is_playing():
		energy_restore_sound.play()
	add_energy_effect($Ship1.global_position)
	add_energy_effect($Ship2.global_position)
	for s in ships:
		add_energy_effect(s.global_position)
	energy = move_toward(energy, max_energy, e * energy_multi)

func add_energy_effect(pos):
	var e = energy_restore_scene.instance()
	e.global_position = pos
	e.set_emitting(true)
	get_parent().add_child(e)

func get_higher_ship():
	if $Ship1.position.y < $Ship2.position.y:
		return $Ship1.position
	else:
		return $Ship2.position
		
func get_leftmost_ship():
	if $Ship1.position.x < $Ship2.position.x:
		return $Ship1.position
	else:
		return $Ship2.position
	
func calc_next_position(currentPosition: Vector2, chain: Chain):
	return currentPosition + Vector2(0, (chain.get_node("CollisionShape2D").get_shape().height/2)+2)
	
func create_chain(nextPosition: Vector2):
	var c = chain_scene.instance()
	add_child(c)
	c.position = nextPosition + Vector2(0, c.get_node("CollisionShape2D").get_shape().height/2)
	return c

func create_joint(p: Vector2, node_a: NodePath):
	var j = PinJoint2D.new()
	add_child(j)
	j.position = p
	j.bias = bias
	j.set_softness(softness)
	j.set_node_a(node_a)
	return j

func array_is_included_in_array(array1, array2):
	for item in array1:
		if !array2.has(item): return false
		if array1.count(item) != array2.count(item): return false
	return true
	
func is_formation_done(formation):
	#Get the ships in the formation shape
	var areas = formation.get_overlapping_areas()
	#Check if all the Connecting ships are inside the formation
	if array_is_included_in_array(ships, areas):
		#Check if the ends of the formation have the Main Ships
		var ship1_in_1 = formation.get_node("End1").overlaps_body($Ship1)
		var ship1_in_2 = formation.get_node("End2").overlaps_body($Ship1)
		var ship2_in_1 = formation.get_node("End1").overlaps_body($Ship2)
		var ship2_in_2 = formation.get_node("End2").overlaps_body($Ship2)
		if (ship1_in_1 and ship2_in_2) or (ship1_in_2 and ship2_in_1):
			return true
	return false


func _on_ShotTimer_timeout():
	#Add sound here
	if is_shooting:
		create_shot($Ship1.global_position + Vector2($Ship1/ShipSprite.texture.get_width()/2, 0), damage)
		create_shot($Ship2.global_position + Vector2($Ship2/ShipSprite.texture.get_width()/2, 0), damage)
		for s in ships:
			create_shot(s.global_position + Vector2(10,0), damage)
	
	
func create_shot(p: Vector2, d: int):
	var shot = shot_scene.instance()
	var shot_effect = shot_spawn_scene.instance()
	shot_effect.position = p
	shot.position = p
	shot.damage = d
	get_tree().root.add_child(shot)
	get_tree().root.add_child(shot_effect)

func clear_formation():
	is_in_formation = false
	if not Input.is_action_pressed("keep_formation"):
		for c in chains:
			c.set_mode(RigidBody2D.MODE_RIGID)

func _on_InviTimer_timeout():
	$Ship1.blink = false
	$Ship2.blink = false

func set_cadence(c: float):
	$ShotTimer.wait_time = c

func set_speed_mod(m):
	$Ship1.spd_mod = m
	$Ship2.spd_mod = m

func stop_shooting():
	is_shooting = false
	
func start_shooting():
	is_shooting = true
