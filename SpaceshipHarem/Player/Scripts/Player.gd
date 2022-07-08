extends Node2D

export var starting_ships = 5
export var health = 5
export var softness = 0.1
export var bias = 0
export var cadence = 0.5
export var max_energy = 100
export var delta_energy = 0.5

var energy : float = 0
var ships : Array
var ship_scene = preload("res://Player/SmallShip.tscn")
var chain_scene = preload("res://Player/Chain.tscn")
var shot_scene = preload("res://Player/Shot.tscn")

func _ready():
	$ShotTimer.start(cadence)
	var nextPosition = $Ship1.position
	
	#Variable of node a
	var lastNode = NodePath($Ship1.get_path())
	
	#Create joint and attach Ship1
	var j = create_joint($Ship1.position, lastNode)
	
	#Create first chain and attach it to joint
	var chain = create_chain(nextPosition)
	nextPosition = chain.position
	lastNode = NodePath(chain.get_path())
	j.set_node_b(lastNode)
	
	#Calculate next position
	nextPosition = calc_next_position(chain.position, chain)
	
	for i in starting_ships:
		#Create ship and put it at the end of the chain
		var s = ship_scene.instance()
		s.position = Vector2(0, chain.get_node("CollisionShape2D").get_shape().height/2)
		get_node(lastNode).add_child(s)
		
		#Add ship to ship list
		ships.append(s)
		
		#Add a joint and attach the last chain to it
		j = create_joint(nextPosition, lastNode)
		
		#Create next chain and attach it to joint
		chain = create_chain(nextPosition)
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
	
func _physics_process(delta):
	if collide_with_enemies():
		health -= 1
	
	if Input.is_action_pressed("activate_formation"):
		for f in $Formations.get_children():
			if f.energy <= energy:
				var s = 1 + (starting_ships * 0.1 - 0.5 )
				f.position = get_higher_ship()
				f.scale = Vector2(s, s)
				if is_formation_done(f):
					print(f)
					energy -= f.energy
			
func _process(delta):
	energy = move_toward(energy, max_energy, delta_energy)
		
func collide_with_enemies():
	var bodies = $Ship1.get_colliding_bodies() + $Ship2.get_colliding_bodies()
	for b in bodies:
		if b.get_collision_layer() == 4:
			b.queue_free()
			return true
	
	return false
		
func take_damage(damage):
	#Add damage sound here
	health -= damage
	if health <= 0:
		queue_free()

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

func calculate_position(s: PinJoint2D):
	return lerp(get_node(s.get_node_a()).position, get_node(s.get_node_b()).position, 0.5)
	
func array_is_included_in_array(array1, array2):
	for item in array1:
		if !array2.has(item): return false
		if array1.count(item) != array2.count(item): return false
	return true
	
func is_formation_done(formation):
	var areas = formation.get_overlapping_areas()
	if array_is_included_in_array(ships, areas):
		var ship1_in_1 = formation.get_node("End1").overlaps_body($Ship1)
		var ship1_in_2 = formation.get_node("End2").overlaps_body($Ship1)
		var ship2_in_1 = formation.get_node("End1").overlaps_body($Ship2)
		var ship2_in_2 = formation.get_node("End2").overlaps_body($Ship2)
		if (ship1_in_1 and ship2_in_2) or (ship1_in_2 and ship2_in_1):
			return true
	return false


func _on_ShotTimer_timeout():
	#Add sound here
	create_shot($Ship1.global_position + Vector2($Ship1/ShipSprite.texture.get_width()/2, 0))
	create_shot($Ship2.global_position + Vector2($Ship2/ShipSprite.texture.get_width()/2, 0))
	for s in ships:
		create_shot(s.global_position)
	$ShotTimer.start(cadence)
	
func create_shot(p: Vector2):
	var shot = shot_scene.instance()
	shot.position = p
	get_tree().root.add_child(shot)
