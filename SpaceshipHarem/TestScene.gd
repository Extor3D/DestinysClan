extends Node2D

var enemy_scene = preload("res://Enemies/Enemy.tscn")
var obstacle_scene = preload("res://Scenery/Column.tscn")
var tunnel_size = 200
var current_tunnel_y = 240
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	if has_node("Player"):
		$HUD/Label.text = str($Player.energy)
	for c in $CleanWhenOut.get_children():
		if c is Node2D:
			if c.global_position.x < -50:
				c.queue_free()

func _on_EnemyTimer_timeout():
	var enemy = enemy_scene.instance()
	enemy.global_position = Vector2(640, 10 + randi()%460)
	$CleanWhenOut.add_child(enemy)

func _on_ObstacleTimer_timeout():
	spawn_tunnel()

func spawn_tunnel():
	var rot = 0
	var rand = rng.randi_range(-100, 100)
	var next_y = clamp(current_tunnel_y + rand, 100, 380)
	rot = Vector2(0, current_tunnel_y).angle_to_point(Vector2(110, next_y))
	current_tunnel_y -= (current_tunnel_y-next_y)/2
	spawn_wall(Vector2(800, current_tunnel_y - tunnel_size/2), rot)
	spawn_wall(Vector2(800, current_tunnel_y + tunnel_size/2), rot+PI)
	current_tunnel_y = next_y
	tunnel_size = clamp(tunnel_size + rng.randi_range(-50, 50), 150, 500)
	
func spawn_wall(position, rotation):
	var obs = obstacle_scene.instance()
	obs.global_position = position
	obs.global_rotation = rotation
	$CleanWhenOut.add_child(obs)
