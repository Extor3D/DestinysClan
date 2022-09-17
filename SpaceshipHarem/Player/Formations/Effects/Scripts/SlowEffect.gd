extends Node2D

func _ready():
	get_parent().set_speed_mod(2)
	Engine.time_scale = 0.5

func _physics_process(_delta):
	position = get_parent().get_higher_ship()

func _on_EffectTime_timeout():
	get_parent().set_speed_mod(1)
	Engine.time_scale = 1
	get_parent().clear_formation()
	queue_free()
