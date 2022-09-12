extends Node2D

export(int, 1, 100) var size = 1

onready var laser_graphic = $Laser
onready var warning_graphic = $Warning
onready var warning_timer = $WarningTime
onready var laser_effect = $LaserEffect
onready var laser_collision = $LaserEffect/LaserCollision

var on = false

func _ready():
	laser_graphic.hide()
	laser_graphic.scale = Vector2(1, size)
	warning_graphic.scale = Vector2(1, size)
	var w_color = Global.WARNING_COLOR
	w_color.a = 0.5
	warning_graphic.color = w_color
	laser_collision.scale = Vector2(1, size)

func deactivate():
	queue_free()
	

func _on_WarningTime_timeout():
	warning_graphic.hide()
	laser_graphic.visible = true
	on = true

func _on_LaserEffect_body_entered(body):
	if on:
		body.take_damage(1)
