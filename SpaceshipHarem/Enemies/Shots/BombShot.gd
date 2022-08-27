extends Node2D

export (float, 0.1, 3) var warn_time = 1
export (int, 1, 100) var radius = 30

onready var timer = $WarningTimer
onready var explosion = $ExplosionRange

func _ready():
	explosion.get_node("CollisionShape2D").shape.radius = radius
	timer.start(warn_time)

func _process(_delta):
	update()

func _draw():
	draw_circle(Vector2(0,0), radius, Color(1, 0.1, 0.1, 0.5))
	draw_circle(Vector2(0,0), lerp(0, radius, (warn_time - timer.time_left) / warn_time), Color.red)

func _on_WarningTimer_timeout():
	for b in explosion.get_overlapping_bodies():
		b.take_damage(1)
		break
	queue_free()
