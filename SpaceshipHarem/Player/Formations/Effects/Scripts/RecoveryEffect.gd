extends Node2D

var pos_mod : Vector2 = Vector2(0,0)
var previous_delta 

func _physics_process(_delta):
	position = get_parent().get_leftmost_ship() + pos_mod

func _on_EffectTime_timeout():
	if  (get_parent().health < get_parent().max_health):
		#get_parent().energy += 5
		get_parent().health += 1
	get_parent().clear_formation()
	queue_free()
