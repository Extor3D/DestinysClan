extends Area2D

export(float) var energy = 10
var effect_scene = preload("res://Player/Formations/Effects/SlowEffect.tscn")

func do_effect(scale):
	#Scale and position the formation in the higher ship position.
	var effect = effect_scene.instance()
	effect.scale = Vector2(scale, scale)
	get_parent().owner.add_child(effect)
