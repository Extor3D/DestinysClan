extends RigidBody2D

var movement = Vector2.ZERO
var speed = 500

func _process(delta):
	movement = Vector2.ZERO
	if Input.is_action_pressed("ship2_left"):
		movement.x = -speed
	if Input.is_action_pressed("ship2_right"):
		movement.x = speed
	if Input.is_action_pressed("ship2_up"):
		movement.y = -speed
	if Input.is_action_pressed("ship2_down"):
		movement.y = speed

func _physics_process(delta):
	apply_central_impulse(movement*delta)
