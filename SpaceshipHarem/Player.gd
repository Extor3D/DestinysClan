extends Node2D

export var starting_ships = 10
export var softness = 0.1
export var bias = 0
var line : Line2D
var ships : Array
var ship_scene = preload("res://SmallShip.tscn")
var chain_scene = preload("res://Chain.tscn")
var guei

func _ready():
	#line = $Line
	#line.add_point($Ship1.position)
	
	#Variable of node a
	var lastNode = NodePath($Ship1.get_path())
	
	#Create joint and attach Ship1
	var j = create_joint($Ship1.position)
	j.set_node_a(lastNode)
	
	#Create first chain and attach it to joint
	var chain = chain_scene.instance()
	var nextPosition = $Ship1.position + Vector2(0, chain.get_node("CollisionShape2D").get_shape().height/2)
	add_child(chain)
	lastNode = NodePath(chain.get_path())
	chain.position = nextPosition
	j.set_node_b(lastNode)
	
	#Calculate next position
	nextPosition = chain.position + Vector2(0, (chain.get_node("CollisionShape2D").get_shape().height/2)+2)
	
	for i in starting_ships:
		#Create ship and put it at the end of the chain
		var s = ship_scene.instance()
		s.position = Vector2(0, chain.get_node("CollisionShape2D").get_shape().height/2)
		ships.append(s)
		get_node(lastNode).add_child(s)
		
		
		#Add a joint and attach the last chain to it
		j = PinJoint2D.new()
		j.position = nextPosition
		j.set_softness(softness)
		j.set_node_a(lastNode)
		j.bias = bias
		add_child(j)
		
		#Create next chain and attach it to joint
		var c = chain_scene.instance()
		add_child(c)
		lastNode = NodePath(c.get_path())
		nextPosition = nextPosition + Vector2(0, c.get_node("CollisionShape2D").get_shape().height/2)
		c.position = nextPosition
		j.set_node_b(lastNode)
		
		#Calculate next position
		nextPosition = c.position + Vector2(0, (c.get_node("CollisionShape2D").get_shape().height/2)+2)
		
	
	#Create final joint
	j = PinJoint2D.new()
	j.position = nextPosition
	j.set_softness(softness)
	j.bias = bias
	$Ship2.position = nextPosition
	add_child(j)
	#Attach ship and last node to joint
	j.set_node_a(lastNode)
	j.set_node_b(NodePath($Ship2.get_path()))
	#line.add_point($Ship2.position)
	pass

func create_joint(p : Vector2):
	var j = PinJoint2D.new()
	add_child(j)
	j.position = p
	j.bias = bias
	j.set_softness(softness)
	return j

func calculate_position(s : PinJoint2D):
	return lerp(get_node(s.get_node_a()).position, get_node(s.get_node_b()).position, 0.5)
	

func get_weight(i, size):
	return (float(i+1))/(size+1)
