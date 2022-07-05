extends KinematicBody2D

export(float) var speed = 500
export(int) var damage = 1

func _physics_process(delta):
	move_and_collide(Vector2(speed * delta, 0))
