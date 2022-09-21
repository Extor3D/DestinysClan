extends Node2D


onready var blend_tween = $BlendOut
onready var white = $White
onready var gameover = $GameOver


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#blend_tween.interpolate_property(gameover, "modulate:a", 3, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#blend_tween.start()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		Global.goto_scene("res://UI/Intro/IntroSplashScreen.tscn")
