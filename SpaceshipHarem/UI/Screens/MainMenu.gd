extends Node2D

onready var start_button = $VBoxContainer/HBoxContainer/VBoxContainer/StartButton
onready var intro_music = $IntroMusic

func _ready():
	start_button.grab_focus()
	intro_music.play()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_StartButton_pressed():
	Global.new_game()
	Global.goto_scene("res://LevelComponents/LevelGenerator.tscn")


func _on_OptionsButton_pressed():
	Global.goto_scene("res://UI/Screens/OptionsMenu.tscn")
