extends Node2D

export var starting_ships = 5
export var softness = 0.1
export var bias = 0
var ships : Array
var ship_scene = preload("res://Player/SmallShip.tscn")
var chain_scene = preload("res://Player/Chain.tscn")

func _ready():
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
	for f in $Formations.get_children():
		var s = 1 + (starting_ships*0.1 - 0.5 )
		f.position = get_higher_ship()
		f.scale = Vector2(s, s)
		is_formation_done(f)
		
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
	#if array1.size() != array2.size(): return false
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
			print("Formation!")
