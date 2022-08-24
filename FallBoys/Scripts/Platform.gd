extends KinematicBody2D

var fall_spd = Vector2.ZERO
export var grav = 5
export var max_speed = 200

func _physics_process(delta):
	fall_spd.y += grav
	fall_spd.y = clamp(fall_spd.y, 0, max_speed)
	move_and_slide(fall_spd)
