extends Timer


var obstacle_scene = preload("res://Scenery/Column.tscn")

export (float) var start_time = 0
export (float) var duration = 5

export (float) var wall_y = 20

var rng = RandomNumberGenerator.new()

func _ready():
	$StartTime.start(start_time)
	set_paused(true)

func spawn_tunnel():
	#Spawn both walls from the center
	spawn_wall(Vector2(800, wall_y), PI/float(2))
	
	
func spawn_wall(position, rotation):
	#Create a wall with position and rotation
	var obs = obstacle_scene.instance()
	obs.global_position = position
	obs.global_rotation = rotation
	get_parent().add_child(obs)

func _process(delta):
	#Loop all the nodes in CleanWhenOut
	for c in $CleanWhenOut.get_children():
		if c is Node2D:
			if c.global_position.x < -50:
				#Remove the node if it leaves the screen from the left
				c.queue_free()


func _on_StartTime_timeout():
	#Starts the spawner when the start timer timeouts
	set_paused(false)
	if duration > 0:
		$Duration.start(duration)


func _on_Duration_timeout():
	#Stops the spawner when duration timeouts
	set_paused(true)
