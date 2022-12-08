extends Node2D

onready var cont_button = $VBoxContainer/Continue
onready var skip_button = $VBoxContainer/Skip
onready var quit_button = $VBoxContainer/Quit

func _ready():
	cont_button.grab_focus()
	if Global.level != 0:
		skip_button.queue_free()
		cont_button.focus_neighbour_bottom = quit_button.get_path()
		quit_button.focus_neighbour_top = cont_button.get_path()

func _on_Continue_pressed():
	get_tree().paused = false
	queue_free()

func _on_Skip_pressed():
	get_tree().paused = false
	Global.current_difficulty = 0
	Global.goto_scene("res://UI/Screens/LevelSelect.tscn")
	queue_free()

func _on_Quit_pressed():
	get_tree().paused = false
	Global.goto_scene("res://UI/Screens/MainMenu.tscn")
	queue_free()
