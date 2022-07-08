extends Area2D

export(float) var speed = 500
export(int) var damage = 1

func _physics_process(delta):
	global_position.x += speed * delta


func _on_Shot_body_entered(body):
	body.take_damage(damage)
	queue_free()
