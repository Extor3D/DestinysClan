extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		Global.goto_scene("res://UI/Intro/IntroSplashScreen.tscn")
