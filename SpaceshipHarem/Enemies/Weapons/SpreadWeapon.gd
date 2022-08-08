extends Node2D
class_name SpreadWeapon

enum weapons {ROTATING = 1, HALLWAY = 2, CIRCULAR = 3, SHOTGUN = 4, BARRAGE = 5, RANDOM = 6}

onready var shoot_timer = $Timer
onready var rotater = $Rotator

export(PackedScene) var bullet_scene
export(int, 0, 200) var rotate_speed = 10
export(int, -359, 359) var rotate_from = -30
export(int, -359, 359) var rotate_to = 30
export(float, 0, 1, 0.05) var shoot_timer_wait_time = 0.1
export(int, 0, 10) var spawn_point_count = 2
export(int, 0, 500) var radius = 100
export(int, 0, 360) var shot_angle_from = 0
export(int, 0, 360) var shot_angle_to = 80
export(bool) var back_and_forth = true
export(bool) var home_in_player = false

var weapon_rotation
var player_node
var rotation_middle

func _ready():	
	
	if home_in_player:
		var nodes = get_tree().get_nodes_in_group("Player")
		if len(nodes) > 0:
			player_node = nodes[0].get_node("Ship1")
	else:
		rotate_to += 180
		rotate_from += 180
	
	var step = deg2rad((shot_angle_to-shot_angle_from) / spawn_point_count)
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time
	shoot_timer.start()
	
	rotation_middle = (rotate_to - rotate_from) / 2
	weapon_rotation = rotate_from
	
	
func set_spread(type, diff):
	match type:
		weapons.ROTATING:
			set_rotating_spread(diff)
		weapons.CIRCULAR:
			set_circular_spread(diff)
		weapons.BARRAGE:
			set_barrage_spread(diff)
		weapons.HALLWAY:
			set_hallway_spread(diff)
		weapons.SHOTGUN:
			set_shotgun_spread(diff)
		weapons.RANDOM:
			set_random_spread(diff)

func set_random(diff):
	set_spread(randi() % weapons.size() + 1, diff)

func _process(delta):	
	var rot_mod = 0
	if is_instance_valid(player_node):
		rot_mod = rad2deg(get_angle_to(player_node.global_position)) - rotation_middle
		
	var new_rotation = weapon_rotation + rotate_speed * delta
	if new_rotation > rotate_to:
		if back_and_forth:
			rotate_speed = rotate_speed * -1
		else:	
			new_rotation = rotate_from
	else:
		if new_rotation < rotate_from:
			rotate_speed = rotate_speed * -1
	weapon_rotation = new_rotation 
	rotater.rotation_degrees = new_rotation + rot_mod
	

func _on_ShootTimer_timeout() -> void:
	for s in rotater.get_children():
		var bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
		
func set_rotating_spread(diff):
	var wait = 0.5 - float(diff) * 0.03
	var dic = create_spread_settings(15, -40, 40, wait, 1, 30, 0, 360, true)
	set_spread_settings(dic)
	
func set_hallway_spread(diff):
	var size = 110 - diff*5
	var speed = 5 + diff * 0.5
	var dic = create_spread_settings(speed, -size/2, 0, 0.1, 2, 30, 0, size, true)
	set_spread_settings(dic)
	
func set_circular_spread(diff):
	var wait = 1 - float(diff) * 0.05
	var points = diff + 9
	var dic = create_spread_settings(7, 0, 360, wait, points, 30, 0, 360, false)
	set_spread_settings(dic)
	
func set_shotgun_spread(diff):
	var wait =  5 + (float(diff) * -0.2)
	var points = diff + 4
	var size = 4 + diff
	var dic = create_spread_settings(20, -size, 0, wait, points, 30, 0, size, false)
	set_spread_settings(dic)

func set_barrage_spread(diff):
	var points = diff + 10
	var dic = create_spread_settings(1, -95, -85, 3, points, 30, 0, 180, false)
	set_spread_settings(dic)
	
func set_random_spread(diff):
	var wait = 3 / float(diff)
	var points = (diff + 7) / 2
	var dic = create_spread_settings(27, 0, 360, wait, points, 30, 0, 360, false)
	set_spread_settings(dic)
	
func set_spread_settings(dic : Dictionary):
	for k in dic.keys():
		set(k, dic.get(k))
		
func create_spread_settings(rot_spd, rot_from, rot_to, wait_time, spawn_count, rad, ang_from, ang_to, back_forth) -> Dictionary:
	var spread_settings : Dictionary = {
		"rotate_speed" : rot_spd,
		"rotate_from" : rot_from,
		"rotate_to" : rot_to,
		"shoot_timer_wait_time" : wait_time,
		"spawn_point_count" : spawn_count,
		"radius" : rad,
		"shot_angle_from" : ang_from,
		"shot_angle_to" : ang_to,
		"back_and_forth" : back_forth
	}
	return spread_settings
