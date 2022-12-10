extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/SpecieEnemy.tscn")
var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")
var tertiary_enemy_scene = preload("res://Enemies/Enemy2.tscn")

var types = [
[{"xspeed": -70 - difficulty*3,"cadence":100,"rotation_degrees": 0},[150,-50,50,50],"DI"], # Derecha a izq
[{"xspeed": 70  + difficulty*3,"cadence":100,"rotation_degrees": 180},[300,650,50,50],"ID"], #  Izq a Der
[{"yspeed": 70 + difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 90},[550,550,50,50],"HAR"], # Hacia Arriba
[{"yspeed": -70  -difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 270},[-50,50,50,50],"HAB"], # Hacia Abajo
[{"yspeed": -70  -difficulty*3,"xspeed": -70 ,"cadence":100,"rotation_degrees": 45},[-50,-50,50,50],"DIAG1"],
[{"yspeed": -70  -difficulty*3,"xspeed": 70 ,"cadence":100,"rotation_degrees": 135},[-50,550,50,50],"DIAG2"],
[{"yspeed": 70  -difficulty*3,"xspeed": 70 ,"cadence":100,"rotation_degrees": 225},[400,650,50,50],"DIAG3"],
[{"yspeed": 70  -difficulty*3,"xspeed": -70 ,"cadence":100,"rotation_degrees": 315},[400,-50,50,50],"DIAG4"]
]

# Label interactions
var SEGMENT_TEXTS = ["Hay algo raro aqui...",
"?",
"Kokoro dijo que habria una base en este planeta, pero como sabe que la base sigue ahi?",
"Tendra algun conocido.",
"No es muy conveniente que conozca tantas bases secretas en el camino?",
"O seran solo una serie de antros que frecuentaba?",
"Alerta! ingresando a zona restringida."]
var Chars_Speaking = [Global.Char_Omega,Global.Char_Alpha,Global.Char_Omega,Global.Char_Alpha,Global.Char_Dummy]

var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()

var spawners = []

var rng = RandomNumberGenerator.new()

func start_segment():
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
	var time = 15 + difficulty * 2
	spawners.append(add_enemy_group(time/3,3,primary_enemy_scene,1))
	spawners.append(add_enemy_group(time/3,time/3,secondary_enemy_scene,1))
	spawners.append(add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene,2))
	timer.start(time)
	
func _on_SegmentTime_timeout():
	remove_child(label)
	end_segment()
	
func _ready():
	rng.randomize()
	
	
func load_enemies(enemy):
	primary_enemy_scene = load(enemy)
	
func add_enemy_group(duration,start,enemy,variation):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars
	if variation == 1:
		vars = {"speed": 70 + difficulty*3,
					"turn_speed": rng.randi_range(2, 3),
					"cadence":2}
	else:
		vars = {"speed": 170 + difficulty*3,
					#"turn_speed": rng.randi_range(2, 3),
					"cadence":4}
	spawner.scene_variables = vars
	spawner.y_center = 20 + (60 * rand_range(0,4))
	spawner.height = 20 + (10* difficulty) 
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(1.35 - 0.2 * difficulty)
	add_child(spawner)
	return spawner
