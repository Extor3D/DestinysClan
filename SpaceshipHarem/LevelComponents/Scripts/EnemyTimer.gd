extends Timer

export (PackedScene) var enemy

func _on_EnemyTimer_timeout():
	#Create a new enemy in a random Y position
	var e = enemy.instance()
	e.global_position = Vector2(640, 10 + randi()%460)
	$CleanWhenOut.add_child(e)

func _process(delta):
	#Loop all the nodes in CleanWhenOut
	for c in $CleanWhenOut.get_children():
		if c is Node2D:
			if c.global_position.x < -50:
				#Remove the node if it leaves the screen from the left
				c.queue_free()
