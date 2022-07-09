extends Node2D

var enemy_scene = preload("res://Enemies/Enemy.tscn")
var obstacle_scene = preload("res://Scenery/Column.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	var obs = obstacle_scene.instance()
	obs.global_position = Vector2(700, 10 + randi()%380)
	obs.global_rotation_degrees = -45 + randi() % 90
	$CleanWhenOut.add_child(obs)
