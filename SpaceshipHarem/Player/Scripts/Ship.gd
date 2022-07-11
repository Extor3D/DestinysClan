extends RigidBody2D

enum sides {LEFT, RIGHT}

export(sides) var side
export(Texture) var sprite
export var speed = 500

var movement = Vector2.ZERO
var ship_name = "ship1"
var blink = false

func take_damage(damage):
	get_parent().take_damage(damage)

func _ready():
	get_node("ShipSprite").texture = sprite
	if side == sides.LEFT:
		ship_name = "ship1"
	else:
		ship_name = "ship2"

func _process(delta):
	movement = Vector2.ZERO
	if Input.is_action_pressed(ship_name + "_left"):
		movement.x = -speed
	if Input.is_action_pressed(ship_name + "_right"):
		movement.x = speed
	if Input.is_action_pressed(ship_name + "_up"):
		movement.y = -speed
	if Input.is_action_pressed(ship_name + "_down"):
		movement.y = speed
	
	#Invincibility color
	if blink:
		$ShipSprite.set_modulate(Color.crimson)
	else:
		$ShipSprite.set_modulate(Color.white)

func _physics_process(delta):
	apply_central_impulse(movement*delta)

func _on_Ship_body_entered(body):
	if body.get_collision_layer() == 32:
		body.queue_free()
		take_damage(1)
