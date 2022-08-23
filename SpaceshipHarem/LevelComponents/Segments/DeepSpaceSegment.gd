extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/BeeEnemy.tscn")
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

var rng = RandomNumberGenerator.new()

func start_segment():
	var time = 15 + difficulty * 2
	add_enemy_group(time/3,3,primary_enemy_scene)
	add_enemy_group(time/3,time/3,secondary_enemy_scene)
	add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene)
	timer.start(time)
	
func _on_SegmentTime_timeout():
	end_segment()
	
func _ready():
	rng.randomize()
	
func add_enemy_group(duration,start,enemy):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = {"move_speed": -70 + -difficulty*3,
				"rot_spd": rng.randi_range(2, 3),
				"cadence":100}
	spawner.scene_variables = vars
	spawner.y_center = 20 + (60 * rand_range(0,4))
	spawner.height = 20 + (10* difficulty) 
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(1.35 - 0.2 * difficulty)
	add_child(spawner)
