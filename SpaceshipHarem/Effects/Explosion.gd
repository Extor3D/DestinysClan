extends Node2D

export (int, 1, 1000) var size = 120

func _ready():
	var s = float(size)/70
	self.scale = Vector2(s, s)
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
