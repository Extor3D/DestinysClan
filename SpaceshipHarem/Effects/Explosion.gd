extends Node2D

export (int, 1, 1000) var size = 120

onready var sound = $AudioStreamPlayer2D

func _ready():
	var s = float(size)/70
	self.scale = Vector2(s, s)
	sound.play()
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
