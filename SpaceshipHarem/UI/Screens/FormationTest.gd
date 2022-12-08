extends Node2D

onready var f_container = $FormScroller/FormContainer

func _ready():
	for f in Global.FORMATIONS:
		var b = Button.new()
		b.text = tr(f.name)
		f_container.add_child(b)
		b.connect("button_down", self, "go_to_test", [f.id])
	f_container.get_children()[0].grab_focus()

func go_to_test(i):
	Global.new_game(i)
	Global.goto_scene("res://LevelComponents/FormationTestLevel.tscn")

