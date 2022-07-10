extends Area2D

func _physics_process(delta):
	position = get_parent().get_higher_ship()

func _on_DefenseEffect_area_entered(area):
	area.queue_free()

func _on_DefenseEffect_body_entered(body):
	body.queue_free()

func _on_EffectTime_timeout():
	queue_free()
