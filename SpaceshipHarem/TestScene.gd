extends Node2D

var enemy_scene = preload("res://Enemies/Enemy.tscn")
var obstacle_scene = preload("res://Scenery/Column.tscn")

#Space (in pixels) between walls of the tunnel
var tunnel_size = 200
#Y coordinate of the center of the tunnel
var current_tunnel_y = 240

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	#If the Player is still alive, we get the energy from it
	if has_node("Player"):
		$HUD/Label.text = str($Player.energy)
	#Loop all the nodes in CleanWhenOut
	for c in $CleanWhenOut.get_children():
		if c is Node2D:
			if c.global_position.x < -50:
				#Remove the node if it leaves the screen from the left
				c.queue_free()

func _on_EnemyTimer_timeout():
	#Create a new enemy in a random Y position
	var enemy = enemy_scene.instance()
	enemy.global_position = Vector2(640, 10 + randi()%460)
	$CleanWhenOut.add_child(enemy)

func _on_ObstacleTimer_timeout():
	spawn_tunnel()

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
	$CleanWhenOut.add_child(obs)
