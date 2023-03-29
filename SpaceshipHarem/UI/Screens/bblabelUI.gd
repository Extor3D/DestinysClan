extends Node2D
signal end_label

onready var container = $Container3
onready var label = $Container3/Container2/Label
onready var character = $Container3/Container/Panel2/Character
onready var portrait = $Container3/Container/Panel2/PilotPortrait

var texts
var data
export (int) var texts_number = 0
export (int) var character_data = 0
export var character_img = []
export var talking_pilot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ""
	#portrait.hide()
	label.add_text(texts[0])
	# Revisar esto para que muestre bien todos los recuadros sin forzar el primero
	select_talker(0)
	
func select_talker(number):
	data = Global.equipped_pilots
	if (typeof(character_img[number]) == TYPE_INT):
		talking_pilot = character_img[number]
		data = Global.equipped_pilots[talking_pilot]
		if data.specie != Global.DUMMY_ID:
			portrait.set_data(data)
			portrait.show()
			character.hide()
		else:
			portrait.hide()
			character.show()
			var t = load(Global.Char_Dummy)
			character.texture = t
	else:
		portrait.hide()
		character.show()
		var t = load(character_img[texts_number])
		character.texture = t
		


func manage_text():
	
	if (texts_number < texts.size() -1):
		texts_number += 1
		print(texts_number)
		select_talker(texts_number)
		label.text = ""
		label.add_text(texts[texts_number])
	elif container.visible:
		container.visible = false
		emit_signal("end_label")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		manage_text()
	
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_Z:
#			manage_text()
