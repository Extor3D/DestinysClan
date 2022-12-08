extends Node2D

onready var f_container = $Screen/FormScroller/FormContainer
onready var ships_label = $Screen/CenterContainer/HBoxContainer/Ships

func _ready():
	for f in Global.FORMATIONS:
		var b = Button.new()
		b.text = tr(f.name)
		f_container.add_child(b)
		b.connect("button_down", self, "go_to_test", [f.id])
	f_container.get_children()[0].grab_focus()
	ships_label.text = str(Global.form_test_ships)

func go_to_test(i):
	Global.new_game(i, Global.form_test_ships)
	Global.goto_scene("res://LevelComponents/FormationTestLevel.tscn")

func _on_LessShips_pressed():
	change_ships(-1)

func _on_MoreShips_pressed():
	change_ships(1)

func change_ships(n):
	Global.form_test_ships = clamp(Global.form_test_ships + n, 3, 7)
	ships_label.text = str(Global.form_test_ships)
