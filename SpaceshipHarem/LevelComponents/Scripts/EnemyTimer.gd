extends Timer

export (PackedScene) var enemy
export (int) var y_center = 180
export (int) var height = 80
export (float) var start_time = 0
export (float) var duration = 5
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$StartTime.start(start_time)
	set_paused(true)

func _on_EnemyTimer_timeout():
	#Create a new enemy in the specified range
	if enemy != null:
		var e = enemy.instance()
		e.global_position = Vector2(get_viewport().size.x + 10, rng.randi_range(y_center - height, y_center + height))
		$CleanWhenOut.add_child(e)

func _process(delta):
	#Loop all the nodes in CleanWhenOut
	for c in $CleanWhenOut.get_children():
		if c is Node2D and c.global_position.x < -50:
			#Remove the node if it leaves the screen from the left
			c.queue_free()

func _on_EndTime_timeout():
	#Stops the spawner when duration timeouts
	set_paused(true)

func _on_StartTime_timeout():
	#Starts the spawner when the start timer timeouts
	set_paused(false)
	if duration > 0:
		$EndTime.start(duration)
