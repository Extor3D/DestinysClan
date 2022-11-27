extends Node2D

var pause_scene = preload("res://UI/Screens/PauseScene.tscn")

onready var form_poly = $FormationLimits
onready var player = $Player

func _ready():
	var f = Global.get_form_by_id(Global.current_pilots[0].formation)
	var form_node = load(f.scene_path).instance()
	add_child(form_node)
	var s = 1 + (Global.current_pilots.size() * 0.1 - 0.5 )
	form_poly.scale = Vector2(s, s)
	form_poly.polygon = form_node.get_node("CollisionPolygon2D").polygon
	player.charge_energy(100)

func _input(event):
	if Input.is_action_pressed("quit"):
		var pause = pause_scene.instance()
		add_child(pause)
		get_tree().paused = true
