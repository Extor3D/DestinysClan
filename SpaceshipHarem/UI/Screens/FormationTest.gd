extends Node2D

onready var f_container = $FormScroller/FormContainer

func _ready():
	for f in Global.FORMATIONS:
		var b = Button.new()
		b.text = f.id
		f_container.add_child(b)
		b.connect("button_down", self, "go_to_test", [f.id])

func go_to_test(i):
	Global.new_game(i)
	Global.goto_scene("res://LevelComponents/FormationTestLevel.tscn")

