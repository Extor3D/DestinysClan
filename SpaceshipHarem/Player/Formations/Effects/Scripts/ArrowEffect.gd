extends Node2D

func _ready():
	get_parent().set_cadence(get_parent().cadence / 3)

func _physics_process(_delta):
	position = get_parent().get_higher_ship()

func _on_EffectTime_timeout():
	get_parent().set_cadence(get_parent().cadence)
	get_parent().clear_formation()
	queue_free()
