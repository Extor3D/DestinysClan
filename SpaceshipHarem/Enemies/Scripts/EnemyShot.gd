extends Area2D

export(float) var speed = -150
export(int) var damage = 1

func _process(delta):
	if position.x < -100:
		queue_free()
		
func _physics_process(delta):
	global_position.x += speed * delta


func _on_EnemyShot_body_entered(body):
	body.take_damage(damage)
	queue_free()
