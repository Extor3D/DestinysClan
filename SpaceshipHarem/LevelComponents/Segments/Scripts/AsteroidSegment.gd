extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var obstacle_scene = preload("res://Scenery/Obstacle.tscn")

var rng = RandomNumberGenerator.new()
var spawner

# Label interactions
var SEGMENT_TEXTS = ["Lluvia de Asteroides. Procedamos con precaucion.","Que ninguna nave se acerque a esas rocas."]
var Chars_Speaking = [Global.Char_Dummy,Global.Char_Alpha]
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()


func start_segment():
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
	var time = 15 + difficulty * 2
	add_asteroid_field(time)
	timer.start(time)

func _on_SegmentTime_timeout():
	remove_child(label)
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
