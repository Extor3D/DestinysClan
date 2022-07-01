extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movement = Vector2.ZERO
var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	if movement == Vector2.ZERO:
		pass
	else:
		apply_central_impulse(movement*delta)
	
