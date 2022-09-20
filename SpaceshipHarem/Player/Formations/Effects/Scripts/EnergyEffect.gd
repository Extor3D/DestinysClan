extends Area2D

var pos_mod : Vector2 = Vector2(0,0)
var previous_delta 

func _ready():
	previous_delta = get_parent().delta_energy
	get_parent().delta_energy = 4
	

func _physics_process(_delta):
	position = get_parent().get_higher_ship() + pos_mod

func _on_DefenseEffect_area_entered(area):
	area.queue_free()

func _on_DefenseEffect_body_entered(body):
	body.queue_free()

func _on_EffectTime_timeout():
	if  (get_parent().energy < get_parent().max_energy):
		#get_parent().energy += 5
		get_parent().delta_energy = previous_delta
	get_parent().clear_formation()
	queue_free()
