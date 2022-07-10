extends Area2D

export(float) var energy = 80
var effect_scene = preload("res://Player/Formations/Effects/DefenseEffect.tscn")

func do_effect(scale):
	var effect = effect_scene.instance()
	effect.scale = Vector2(scale, scale)
	effect.position = get_parent().owner.get_higher_ship()
	get_parent().owner.add_child(effect)
