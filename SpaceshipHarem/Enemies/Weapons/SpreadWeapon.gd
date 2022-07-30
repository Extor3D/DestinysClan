extends Node2D

onready var shoot_timer = $Timer
onready var rotater = $Rotator

export(PackedScene) var bullet_scene
export(int, 0, 200) var rotate_speed = 10
export(int, 0, 360) var rotate_from = 135
export(int, 0, 360) var rotate_to = 200
export(float, 0, 1, 0.05) var shoot_timer_wait_time = 0.1
export(int, 0, 10) var spawn_point_count = 2
export(int, 0, 500) var radius = 100
export(int, 0, 360) var shot_angle_from = 0
export(int, 0, 360) var shot_angle_to = 80
export(bool) var back_and_forth = true

func _ready():	
	
	var step = deg2rad((shot_angle_to-shot_angle_from) / spawn_point_count)
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time
	shoot_timer.start()
	
	rotater.rotation_degrees = rotate_from


func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	if new_rotation > rotate_to:
		if back_and_forth:
			rotate_speed = rotate_speed * -1
		else:	
			new_rotation = rotate_from
	if new_rotation < rotate_from:
		rotate_speed = rotate_speed * -1
	rotater.rotation_degrees = new_rotation
	

func _on_ShootTimer_timeout() -> void:
	for s in rotater.get_children():
		var bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation	
