extends Segment

onready var timer = $SegmentTime

var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()


#Backlog
#Las diagonales solo para dificultad 5 o mas
# Bocinazos y ruidos de trafico
# Domingueros e Ira de Carretera para algunos autos
var dificulty = Global.current_difficulty
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/TrafficCar.tscn")

#onready var  honk_sound = preload("res://Enemies/Sounds/honk_sound.mp3")

var car_sound = preload("res://Enemies/Sounds/Traffic/car-horn.mp3")

onready var sound = $AudioStreamPlayer

# Label interactions

var SEGMENT_TEXTS = ["Embotellamiento detectado mas adelante.","Como? Aqui en el espacio?"]

var Chars_Speaking = [Global.Char_Dummy,Global.Char_Omega]


var rng = RandomNumberGenerator.new()

var types = [
[{"xspeed": -70 - difficulty*3,"cadence":100,"rotation_degrees": 0},[150,-50,50,50],"DI"], # Derecha a izq
[{"xspeed": 70  + difficulty*3,"cadence":100,"rotation_degrees": 180},[300,650,50,50],"ID"], #  Izq a Der
[{"yspeed": 70 + difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 270},[550,550,50,50],"HAR"], # Hacia Arriba
[{"yspeed": -70  -difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 90},[-50,50,50,50],"HAB"], # Hacia Abajo
[{"yspeed": -70  -difficulty*3,"xspeed": -70 ,"cadence":100,"rotation_degrees": 45},[-50,-50,50,50],"DIAG1"],
[{"yspeed": -70  -difficulty*3,"xspeed": 70 ,"cadence":100,"rotation_degrees": 135},[-50,550,50,50],"DIAG2"],
[{"yspeed": 70  -difficulty*3,"xspeed": 70 ,"cadence":100,"rotation_degrees": 225},[400,650,50,50],"DIAG3"],
[{"yspeed": 70  -difficulty*3,"xspeed": -70 ,"cadence":100,"rotation_degrees": 315},[400,-50,50,50],"DIAG4"]
] # Hacia Abajo

var spawners = []

func start_segment():
	sound.play()
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
	var time = 10 + difficulty * 3
	var ways = types.size()
	var previous_ways = []
	var way_passed = 3
	var trails = 2
	rng.randomize()
	# Ajustar vueltas por dificultad
	if difficulty > 3:
		if difficulty > 6:
			trails = 4
		else:
			trails = 3
		
	
	for i in 2 :
		for j in trails :
			
			var way = types[rng.randi_range(0, types.size() - 1)]
			var way_id = way[2]
			while previous_ways.has(way_id):
				way = types[rng.randi_range(0, types.size() - 1)]
				way_id = way[2]
			previous_ways.append(way_id)
			spawners.append(add_traffic_line(time/3,way_passed,primary_enemy_scene,way))
		#add_traffic_line(time/3,time/3,primary_enemy_scene,way)
		#add_enemy_group(time/3,time * 2/3,primary_enemy_scene,way)
			
		way_passed += time/3
		
		
		previous_ways.clear()
	timer.start(time)
	
func _on_SegmentTime_timeout():
	remove_child(label)
	sound.stop()

	#for s in spawners:
	#	s.stop()
	end_segment()
	
func _ready():
	rng.randomize()
	
func add_traffic_line(duration,start,enemy,line):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = line[0]
	spawner.scene_variables = vars
	spawner.y_center = line[1][0]
	spawner.x_center = line[1][1]
	spawner.height = line[1][2]
	spawner.width = line[1][3]
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = true
	spawner.set_wait_time(1.35 - (0.2 * difficulty) )
	add_child(spawner)
	return spawner
