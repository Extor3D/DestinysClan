extends Area2D

var pos_mod : Vector2 = Vector2(0,0)
var previous_delta 

func _ready():
	previous_delta = get_parent().delta_energy
	get_parent().delta_energy = 4
	

func _physics_process(_delta):
	position = get_parent().get_higher_ship() + pos_mod

func _on_EffectTime_timeout():
	get_parent().delta_energy = previous_delta
	get_parent().clear_formation()
	queue_free()
