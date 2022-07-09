extends RigidBody2D

var speed = -50

func _process(delta):
	set_axis_velocity(Vector2(speed,0))
