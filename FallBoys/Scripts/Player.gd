extends KinematicBody2D

var velocity = Vector2.ZERO
var air_jump = true
var max_y_speed = 400

export (int) var speed = 100
export (int) var jump_speed = -2000
export (int) var gravity = 500
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.55

func _draw():
	if abs(velocity.x) < 30:
		$AnimatedSprite.animation = "idle"
	else:
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
		else: 
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "idle"

	if not is_on_floor():
		$AnimatedSprite.animation = "falling"
		
func _process(delta):
	_draw()

func _physics_process(delta):
	move_player(delta)
	
func move_player(delta):
	var dir = 0
	var snap = Vector2.DOWN * 32
	if Input.is_action_pressed("move_right"):
		dir += 1

	if Input.is_action_pressed("move_left"):
		dir -= 1

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	velocity.y += gravity * delta
	
	var grounded = is_on_floor()
	if not air_jump and is_on_floor():
		air_jump = true

	if Input.is_action_just_pressed("jump"):
		if grounded:
			velocity.y = jump_speed
			snap = Vector2.ZERO
		elif air_jump:
			velocity.y = jump_speed
			air_jump = false
			
	velocity.y = clamp(velocity.y, -400, max_y_speed)
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true, 2, deg2rad(50), true)
