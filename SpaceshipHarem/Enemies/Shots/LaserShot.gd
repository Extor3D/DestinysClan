extends Node2D

export(int, 1, 100) var size = 10

onready var laser_graphic = $Laser
onready var warning_graphic = $Warning
onready var warning_timer = $WarningTime
onready var laser_effect = $LaserEffect
onready var laser_collision = $LaserEffect/LaserCollision

var on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	laser_graphic.hide()
	laser_graphic.scale = Vector2(1, size)
	warning_graphic.scale = Vector2(1, size)
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
