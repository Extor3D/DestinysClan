extends Node2D

onready var start_button = $VBoxContainer/HBoxContainer/VBoxContainer/StartButton
onready var intro_music = $IntroMusic

func _ready():
	start_button.grab_focus()
	intro_music.play()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_StartButton_pressed():
	Global.level = 0
	Global.goto_scene("res://LevelComponents/LevelGenerator.tscn")
