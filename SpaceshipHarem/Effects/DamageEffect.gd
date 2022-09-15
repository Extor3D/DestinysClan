extends Node2D

onready var spr = $AnimatedSprite

func _ready():
	spr.frame = 0
	spr.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
