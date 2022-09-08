extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var obstacle_scene = preload("res://Scenery/Obstacle.tscn")

var rng = RandomNumberGenerator.new()
var spawner

func start_segment():
	var time = 15 + difficulty * 2
	add_asteroid_field(time)
	timer.start(time)

func _on_SegmentTime_timeout():
	end_segment()

func _ready():
	rng.randomize()

func add_asteroid_field(duration):
	spawner = spawner_scene.instance()
	spawner.scene = obstacle_scene
	var vars = {"speed": -70 + -difficulty*3,
				"rot_spd": rng.randi_range(2, 3)}
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 180
	spawner.start_time = 0
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(2.35 - 0.2 * difficulty)
	add_child(spawner)
