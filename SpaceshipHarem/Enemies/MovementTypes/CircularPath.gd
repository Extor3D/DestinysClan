extends Node2D

export var x_range = 50
export var x_speed = 100
export var y_range = 50
export var y_speed = 100
export var x_start = PI/2
export var y_start = 0

onready var x_pos = x_start
onready var y_pos = y_start
onready var parent : Node2D = get_parent()

var initial_pos = Vector2(0,0)
var enabled = false

func _process(delta):
	if enabled:
		x_pos += x_speed * delta / 100
		parent.position.x = initial_pos.x + sin(x_pos) * x_range
		
		y_pos += y_speed * delta / 100
		parent.position.y = initial_pos.y + sin(y_pos) * y_range
		
func enable():
	enabled = true
	initial_pos = Vector2(parent.position.x - sin(x_pos) * x_range, parent.position.y - sin(y_pos) * y_range)
