extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/TrafficCar.tscn")
#var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")
#var tertiary_enemy_scene = preload("res://Enemies/Enemy2.tscn")

var rng = RandomNumberGenerator.new()

var types = [
[{"xspeed": -70 - difficulty*3,"cadence":100,"rotation_degrees": 0},[150,-50,50,50]], # Derecha a izq
[{"xspeed": 70  + difficulty*3,"cadence":100,"rotation_degrees": 180},[300,650,50,50]], #  Izq a Der
[{"yspeed": 70 + difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 90},[550,550,50,50]], # Hacia Arriba
[{"yspeed": -70  -difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 270},[-150,50,50,50]], # Hacia Abajo
[{"yspeed": -70  -difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 270},[-150,50,50,50]]
] # Hacia Abajo


func start_segment():
	var time = 30 + difficulty * 2
	var ways = types.size()
	var previous_ways = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in difficulty /3 :
		print("Vuelta")
		var way = types[rng.randi_range(0, types.size() - 1)]
		while previous_ways.has(way):
			way = types[rng.randi_range(0, types.size() - 1)]
			print("Repetido")
		
		add_traffic_line(time/3,3,primary_enemy_scene,way)
		previous_ways.append(way)
	#add_enemy_group(time/3,time/3,secondary_enemy_scene)
	#add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene)
	timer.start(time)
	
func _on_SegmentTime_timeout():
	end_segment()
	
func _ready():
	rng.randomize()
	
func add_traffic_line(duration,start,enemy,line):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = line[0]
	#{"yspeed": 70 + difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 90}# Abajo
	spawner.scene_variables = vars
	

	spawner.y_center = line[1][0]
	spawner.x_center = line[1][1]
	spawner.height = line[1][2]
	spawner.width = line[1][3]
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = true
	spawner.set_wait_time(2.35 - 0.2 * difficulty)
	add_child(spawner)
