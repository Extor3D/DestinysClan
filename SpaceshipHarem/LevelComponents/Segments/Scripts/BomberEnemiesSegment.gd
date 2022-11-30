extends Segment

onready var timer = $SegmentTime

var rng = RandomNumberGenerator.new()
var bomber : PackedScene = preload("res://Enemies/BomberEnemy.tscn")

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")

var spawner

var rad = 30
var warn_time = 1

# Label interactions
var SEGMENT_TEXTS = ["Escuadron de Bombarderos mas adelante.","Destruyamoslos antes que lancen sus bombas!"]
var Chars_Speaking = [Global.Char_Dummy,Global.Char_Omega]
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()

func start_segment():
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
	rng.randomize()
	var time = 15 + difficulty * 2
	timer.start(time)
	add_bomber_spawner(time - 2)

func _on_SegmentTime_timeout():
	remove_child(label)
	end_segment()

func add_bomber_spawner(duration):
	spawner = spawner_scene.instance()
	spawner.scene = bomber
	var vars = {"speed": 300 - difficulty * 20,
				"health": 3,
				"cadence": 1 - difficulty * 0.05}
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 180
	spawner.start_time = 0
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(3 - 0.1 * difficulty)
	add_child(spawner)
