extends KinematicBody2D

export(float) var speed = 100
export(int) var health = 10
export(float) var cadence = 0.5
var shot_scene = preload("res://Enemies/EnemyShot.tscn")

func _physics_process(delta):
	var coll = move_and_collide(Vector2(-speed * delta, 0))
	if coll:
		var shot = coll.get_collider()
		health -= shot.damage
		shot.queue_free()
		if health <= 0:
			queue_free()


func _on_ShotTimer_timeout():
	#Add sound here
	create_shot(global_position + Vector2($Sprite.texture.get_width()/2, 0))
	$ShotTimer.start(cadence)
	
func create_shot(p: Vector2):
	var shot = shot_scene.instance()
	shot.position = p
	get_tree().root.add_child(shot)
