extends Node2D
signal end_label

onready var container = $Container3
onready var label = $Container3/Container2/Label
onready var character = $Container3/Container/Panel2/Character

var texts
export (int) var texts_number = 0
export (int) var character_data = 0
export var character_img = []
#= "res://Player/Sprites/candidates/pilot/dummypilot.png"
#"res://Player/Sprites/candidates/pilot/candidate011.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ""
	#label.rect_size.x = 400
	label.add_text(texts[0])
	# Revisar esto para que muestre bien todos los recuadros sin forzar el primero
	var t = load(character_img[0])
	character.texture = t
	
	#var t = load(character_img)
	#character.texture = t
	
	# Agregar dibujitos a los textos
	#var t=Texture.new()
	#t=load(character_img)
	#label.add_image(t,10,10)


func manage_text():
	if (texts_number < texts.size() -1):
		texts_number += 1
		var t = load(character_img[texts_number])
		character.texture = t
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
