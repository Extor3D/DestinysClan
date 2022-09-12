extends RigidBody2D
class_name Chain

func _on_Chain_body_entered(body):
	#When colliding with obstacles (layer 32) remove the obstacle and take damage
	if body.get_collision_layer() == 32:
		body.queue_free()
		take_damage(1)
		
func take_damage(d):
	get_parent().take_damage(d)
	
func charge_energy(energy):
	get_parent().charge_energy(energy)
