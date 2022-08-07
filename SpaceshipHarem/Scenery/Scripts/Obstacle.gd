extends RigidBody2D

export (float) var rot_spd = 0
export (float) var speed = -50

func _process(_delta):
	set_axis_velocity(Vector2(speed,0))
	apply_torque_impulse(rot_spd)
