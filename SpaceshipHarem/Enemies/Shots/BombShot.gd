extends Node2D

signal exploded

export (float, 0.1, 3) var warn_time = 1
export (int, 1, 100) var radius = 30

onready var timer = $WarningTimer
onready var explosion = $ExplosionRange
onready var sound = $AudioStreamPlayer2D


var exp_effect : PackedScene = preload("res://Effects/Explosion.tscn")


func _ready():
	explosion.get_node("CollisionShape2D").shape.radius = radius
	timer.start(warn_time)
	sound.play()

func _process(_delta):
	update()

func _draw():
	draw_circle(Vector2(0,0), radius, Color(1, 0.5, 0.1, 0.5))
	draw_circle(Vector2(0,0), lerp(0, radius, (warn_time - timer.time_left) / warn_time), Color.orange)


func _on_WarningTimer_timeout():
	var eff = exp_effect.instance()
	eff.global_position = self.global_position
	eff.size = radius * 2
	get_tree().root.get_child(0).add_child(eff)
	for b in explosion.get_overlapping_bodies():
		b.take_damage(1)
		break

	emit_signal("exploded")
	queue_free()
