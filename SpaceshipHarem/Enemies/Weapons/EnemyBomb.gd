extends Node2D

export (Vector2) var final_pos = Vector2(320, 180)
export (float, 0.1, 3) var warn_time = 1
export (int, 1, 100) var radius = 30

var warn : PackedScene = preload("res://Enemies/Shots/BombShot.tscn")

onready var tween = $Tween

func _ready():
	tween.interpolate_property(self, "global_position", global_position, final_pos, 1, Tween.TRANS_EXPO)
	tween.start()


func _on_Tween_tween_all_completed():
	var e = warn.instance()
	e.warn_time = warn_time
	e.radius = radius
	e.connect("exploded", self, "queue_free")
	add_child(e)
