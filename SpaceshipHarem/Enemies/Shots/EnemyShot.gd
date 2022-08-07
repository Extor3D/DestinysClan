extends Area2D

export(float) var speed = 150
export(int) var damage = 1


func _physics_process(delta):
	position += transform.x * speed * delta

func _on_EnemyShot_body_entered(body):
	body.take_damage(damage)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
