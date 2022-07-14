extends Timer


var obstacle_scene = preload("res://Scenery/Column.tscn")

export (float) var start_time = 0
export (float) var duration = 5

#Space (in pixels) between walls of the tunnel
var tunnel_size = 200
#Y coordinate of the center of the tunnel
var current_tunnel_y = 240

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$StartTime.start(start_time)
	set_paused(true)

func spawn_tunnel():
	var rot = 0
	#Calculate the next Y position for the tunnel
	var rand = rng.randi_range(-100, 100)
	var next_y = clamp(current_tunnel_y + rand, 100, 380)
	
	#Calculate the rotation between the last and the next Y positions
	rot = Vector2(0, current_tunnel_y).angle_to_point(Vector2(110, next_y))
	
	#Center the Y to adapt for rotation
	current_tunnel_y -= (current_tunnel_y-next_y)/2
	
	#Spawn both walls from the center
	spawn_wall(Vector2(800, current_tunnel_y - tunnel_size/2), rot)
	spawn_wall(Vector2(800, current_tunnel_y + tunnel_size/2), rot+PI)
	
	#Set current Y for next tunnel piece
	current_tunnel_y = next_y
	
	#Change the spacing between walls for the next piece
	tunnel_size = clamp(tunnel_size + rng.randi_range(-50, 50), 150, 500)
	
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
