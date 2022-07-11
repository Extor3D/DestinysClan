extends RigidBody2D
class_name Chain

func _on_Chain_body_entered(body):
	#When colliding with obstacles (layer 32) remove the obstacle and take damage
	if body.get_collision_layer() == 32:
		body.queue_free()
		get_parent().take_damage(1)
		
		
