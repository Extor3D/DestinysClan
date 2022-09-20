extends Area2D

export(float) var speed = 800
export(int) var damage = 1

var effect = preload("res://Effects/DamageEffect.tscn")

func _process(_delta):
	if position.x > 700:
		queue_free()

func _physics_process(delta):
	global_position.x += speed * delta
	scale.x += 0.05

func _on_Shot_body_entered(body):
	body.take_damage(damage)
	var e = effect.instance()
	e.global_position = global_position
	get_tree().root.get_child(0).add_child(e)
	queue_free()
