extends Node2D

signal formation_done
signal game_over

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

onready var d_tween = $DeathTween

var is_in_formation = false

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
			$Formations.add_child(form_node)
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
	
	#Formations logic
	if Input.is_action_pressed("activate_formation") and not is_in_formation:
		#Iterate all formations when button pressed
		for f in $Formations.get_children():
			if f.energy <= energy:
				#Calculate scaling based on number of ships
				var s = 1 + (Global.current_pilots.size() * 0.1 - 0.5 )
				f.scale = Vector2(s, s)
				f.position = $Ship1.position
				yield(get_tree().create_timer(0.01), "timeout")
				if is_formation_done(f):
					do_formation(f, s)
				else:
					f.position = $Ship2.position
					if is_formation_done(f):
						do_formation(f, s)
					
func do_formation(f, s):
	is_in_formation = true
	emit_signal("formation_done")
	f.do_effect(s)
	#Change the mode of the chains to keep them in place
	for c in chains:
		c.set_mode(RigidBody2D.MODE_CHARACTER)
	energy -= f.energy
			
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
	emit_signal("game_over")
	yield(get_tree().create_timer(0.1), "timeout")
	#Explotar miticamente
	queue_free()
	
			
func charge_energy(e):
	energy = move_toward(energy, max_energy, e * energy_multi)

func get_higher_ship():
	if $Ship1.position.y < $Ship2.position.y:
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
	create_shot($Ship1.global_position + Vector2($Ship1/ShipSprite.texture.get_width()/2, 0), damage)
	create_shot($Ship2.global_position + Vector2($Ship2/ShipSprite.texture.get_width()/2, 0), damage)
	for s in ships:
		create_shot(s.global_position, damage)
	
	
func create_shot(p: Vector2, d: int):
	var shot = shot_scene.instance()
	shot.position = p
	shot.damage = d
	get_tree().root.add_child(shot)

func clear_formation():
	is_in_formation = false
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
