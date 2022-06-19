extends RigidBody2D

var rot = (randf() * 3) - 2
export var max_speed = 5.0

func _ready():
	angular_velocity = rot
	
func _integrate_forces(state):
	if state.linear_velocity.length()>max_speed:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed
