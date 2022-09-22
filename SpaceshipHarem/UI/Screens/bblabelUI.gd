extends Node2D
signal end_label

onready var container = $Container
onready var label = $Container/Label
onready var button = $Button


var texts
export (int) var texts_number = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ""
	label.add_text(texts[0])


func manage_text():
	if (texts_number < texts.size() -1):
		texts_number += 1
		label.text = ""
		label.add_text(texts[texts_number])
	elif container.visible:
		container.visible = false
		emit_signal("end_label")


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		manage_text()
	
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_Z:
#			manage_text()
