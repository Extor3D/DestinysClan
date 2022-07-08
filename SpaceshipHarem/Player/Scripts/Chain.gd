extends RigidBody2D
class_name Chain

func _on_Chain_body_entered(body):
	if body.get_collision_layer() == 32:
		body.queue_free()
		get_parent().take_damage(1)
		
		
