extends Segment

onready var timer = $SegmentTime
onready var laser_timer = $LaserSpawnTimer

var rng = RandomNumberGenerator.new()
var laser : PackedScene = preload("res://Enemies/Shots/LaserShot.tscn")

var l_size = 10
var l_time = 1
var warn_time = 1

# Label interactions
var SEGMENT_TEXTS = ["Lluvia de laseres detectada en esta zona.","Preparemonos maniobras evasivas."]
var Chars_Speaking = [Global.Char_Dummy,Global.Char_Omega]
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()

func start_segment():
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
	rng.randomize()
	var time = 15 + difficulty * 2
	var laser_time = 0.85 - float(difficulty)/25
	l_size = 10
	l_time = 1.5 + difficulty * 0.1
	timer.start(time)
	laser_timer.start(laser_time)

func _on_SegmentTime_timeout():
	laser_timer.stop()
	remove_child(label)
	end_segment()


func _on_LaserSpawnTimer_timeout():
	var l = laser.instance()
	l.global_position = Vector2(rng.randi_range(30, 780), -100)
	l.size = l_size
	l.rotation_degrees = 110
	var t = get_tree().create_timer(l_time)
	t.connect("timeout", l, "deactivate")
	#var t = Timer
	add_child(l)
