extends Node2D
class_name LaserWeapon

enum weapons {ROTATING = 1, HALLWAY = 2, CIRCULAR = 3}

onready var laser_timer_on = $TimerOn
onready var laser_timer_off = $TimerOff
onready var rotater = $Rotator

export(int, 0, 200) var rotate_speed = 10
export(int, -359, 359) var rotate_from = -30
export(int, -359, 359) var rotate_to = 30
export(float, 0, 5, 0.5) var laser_timer_hold_on = 0.5
export(float, 0, 10, 0.5) var laser_timer_hold_off = 0.5
export(int, 0, 10) var spawn_point_count = 2
export(int, 0, 500) var radius = 100
export(int, 0, 360) var laser_angle_from = 0
export(int, 0, 360) var laser_angle_to = 80
export(int, 1, 100) var laser_size = 10
export(bool) var back_and_forth = true
export(bool) var home_in_player = false

var laser_scene : PackedScene = preload("res://Enemies/Shots/LaserShot.tscn")

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
	
	var step = deg2rad((laser_angle_to-laser_angle_from) / spawn_point_count)
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	laser_timer_off.wait_time = laser_timer_hold_off
	laser_timer_on.wait_time = laser_timer_hold_on
	laser_timer_off.start()
	
	rotation_middle = (rotate_to - rotate_from) / 2
	weapon_rotation = rotate_from
	
	
	
func set_spread(type, diff):
	match type:
		weapons.ROTATING:
			set_rotating_spread(diff)
		weapons.CIRCULAR:
			set_circular_spread(diff)
		weapons.HALLWAY:
			set_hallway_spread(diff)

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
		var laser = laser_scene.instance()
		s.add_child(laser)
		laser.position = s.position
		laser.rotation = s.rotation
		laser.size = laser_size
	laser_timer_on.stop()
	laser_timer_off.start()
		
func _on_TimerOff_timeout():
	for s in rotater.get_children():
		for l in s.get_children():
			l.deactivate()
	laser_timer_off.stop()
	laser_timer_on.start()
		
func set_rotating_spread(diff):
	var wait_on = 2 + float(diff) * 0.2
	var wait_off = 5 - float(diff) * 0.2
	var size = 5 + float(diff) * 2
	var dic = create_spread_settings(15, -40, 40, wait_on, wait_off, 1, 30, 0, 360, size, true)
	set_spread_settings(dic)
	
func set_hallway_spread(diff):
	var space = 110 - diff * 5
	var speed = 5 + diff * 0.5
	var size = 5 + float(diff) * 2
	var dic = create_spread_settings(speed, -size/2, 0, 10, 5, 2, 30, 0, space, size, true)
	set_spread_settings(dic)
	
func set_circular_spread(diff):
	var wait_on = 0.5 + float(diff) * 0.2
	var wait_off = 2 - float(diff) * 0.2
	var points = diff + 9
	var size = 5 + float(diff) * 2
	var dic = create_spread_settings(7, 0, 360, wait_on, wait_off, points, 30, 0, 360, size, false)
	set_spread_settings(dic)
	
func set_spread_settings(dic : Dictionary):
	for k in dic.keys():
		set(k, dic.get(k))
		
func create_spread_settings(rot_spd, rot_from, rot_to, lsr_on, lsr_off, spawn_count, rad, lsr_from, lsr_to, lsr_size, back_forth) -> Dictionary:
	var spread_settings : Dictionary = {
		"rotate_speed" : rot_spd,
		"rotate_from" : rot_from,
		"rotate_to" : rot_to,
		"laser_timer_hold_on" : lsr_on,
		"laser_timer_hold_off" : lsr_off,
		"spawn_point_count" : spawn_count,
		"radius" : rad,
		"laser_angle_from" : lsr_from,
		"laser_angle_to" : lsr_to,
		"laser_angle_size" : lsr_size,
		"back_and_forth" : back_forth
	}
	return spread_settings
