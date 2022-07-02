extends RigidBody2D

var movement = Vector2.ZERO
var speed = 500

func _process(delta):
	movement = Vector2.ZERO
	if Input.is_action_pressed("ship1_left"):
		movement.x = -speed
	if Input.is_action_pressed("ship1_right"):
		movement.x = speed
	if Input.is_action_pressed("ship1_up"):
		movement.y = -speed
	if Input.is_action_pressed("ship1_down"):
		movement.y = speed

func _physics_process(delta):
	apply_central_impulse(movement*delta)
	
