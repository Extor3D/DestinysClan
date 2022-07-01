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
	var j = PinJoint2D.new()
	add_child(j)
	j.position = $Ship1.position
	j.bias = bias
	j.set_softness(softness)
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
		#Add a ship joint and attach the last chain to it
		var s = ship_scene.instance()
		s.position = nextPosition
		s.set_softness(softness)
		s.set_node_a(lastNode)
		s.bias = bias
		add_child(s)
		ships.append(s)
		
		#Create next chain and attach it to ship joint
		var c = chain_scene.instance()
		add_child(c)
		lastNode = NodePath(c.get_path())
		nextPosition = nextPosition + Vector2(0, c.get_node("CollisionShape2D").get_shape().height/2)
		c.position = nextPosition
		s.set_node_b(lastNode)
		
		
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

#func _draw():
	#draw_line($Ship1.position, $Ship2.position, Color.blueviolet)	

func _process(delta):
	for s in ships:
		s.position = calculate_position(s)
		#Calcular posicion de cada punto
		pass
#	line.set_point_position(0, $Ship1.position)
#	for i in ships.size():
#		line.set_point_position(i + 1, lerp($Ship1.position, $Ship2.position, get_weight(i, ships.size())))
#		ships[i].position = line.get_point_position(i + 1)
#	line.set_point_position(ships.size() + 1, $Ship2.position)
#	update()

func calculate_position(s : PinJoint2D):
	return lerp(get_node(s.get_node_a()).position, get_node(s.get_node_b()).position, 0.5)
	

func get_weight(i, size):
	return (float(i+1))/(size+1)
