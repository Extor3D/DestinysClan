extends Area2D

export(float) var energy = 10
export(PackedScene) var effect_scene
var id = ""

func do_effect(scale):
	#Scale and position the formation in the higher ship position.
	var effect = effect_scene.instance()
	effect.scale = Vector2(scale, scale)
	effect.pos_mod = Vector2(35,0)
	get_parent().owner.add_child(effect)
	
