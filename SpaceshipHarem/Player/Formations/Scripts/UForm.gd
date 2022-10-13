extends Area2D

export(float) var energy = 20
export(PackedScene) var effect_scene

func do_effect(scale):
	#Scale and position the formation in the higher ship position.
	var effect = effect_scene.instance()
	effect.scale = Vector2(scale, scale)
	effect.position = get_parent().owner.get_leftmost_ship()
	get_parent().owner.add_child(effect)
