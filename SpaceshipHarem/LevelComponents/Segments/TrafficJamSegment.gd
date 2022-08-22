extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/TrafficCar.tscn")
#var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")
#var tertiary_enemy_scene = preload("res://Enemies/Enemy2.tscn")

var rng = RandomNumberGenerator.new()

func start_segment():
	var time = 30 + difficulty * 2
	add_enemy_group(time/3,3,primary_enemy_scene)
	#add_enemy_group(time/3,time/3,secondary_enemy_scene)
	#add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene)
	timer.start(time)
	
func _on_SegmentTime_timeout():
	end_segment()
	
func _ready():
	rng.randomize()
	
func add_enemy_group(duration,start,enemy):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = {"speed": -70 + -difficulty*3,
				"rot_spd": rng.randi_range(2, 3),
				"cadence":100}
	spawner.scene_variables = vars
	spawner.y_center = 150
	spawner.x_center = -50
	spawner.height = 50
	spawner.width = 50
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = true
	spawner.set_wait_time(2.35 - 0.2 * difficulty)
	add_child(spawner)
