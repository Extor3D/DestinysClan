extends KinematicBody2D

export(float) var speed = 100
export(int) var health = 100
export(int) var hold_x = 580
export(int, 1, 10) var difficulty = 1

var normal_bullet : PackedScene = preload("res://Enemies/EnemyShot.tscn")
var spread : PackedScene = preload("res://Enemies/Weapons/SpreadWeapon.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var weapon1 = rng.randi_range(1, 6)
	add_weapon(weapon1, difficulty)
	var weapon2 = rng.randi_range(1, 6)
	while weapon1 == weapon2:
		weapon2 = rng.randi_range(1, 6)
	add_weapon(weapon2, difficulty)
	if difficulty > 5:
		var weapon3 = rng.randi_range(1, 6)
		while weapon1 == weapon3 or weapon2 == weapon3:
			weapon3 = rng.randi_range(1, 6)
		add_weapon(weapon3, difficulty - 3)

func _physics_process(delta):
	if position.x > hold_x:
		move_and_collide(Vector2(-speed * delta, 0))

func take_damage(damage):
	#Add damage sound here
	health -= damage
	if health <= 0:
		queue_free()

func add_weapon(wpn, diff):
	match wpn:
		1: add_rotating_spread(diff)
		2: add_hallway_spread(diff)
		3: add_circular_spread(diff)
		4: add_shotgun_spread(diff)
		5: add_barrage_spread(diff)
		6: add_random_spread(diff)

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
	
func add_rotating_spread(diff):
	var wait = 0.5 - float(diff) * 0.03
	var dic = create_spread_settings(15, 140, 220, wait, 1, 30, 0, 360, true)
	var spr = spread.instance()
	set_spread_settings(spr, dic)
	add_child(spr)
	
func add_hallway_spread(diff):
	var size = 160 - diff*10
	var speed = diff * 1.5
	var dic = create_spread_settings(speed, 180-size/2, 180, 0.1, 2, 30, 0, size, true)
	var spr = spread.instance()
	set_spread_settings(spr, dic)
	add_child(spr)
	
func add_circular_spread(diff):
	var wait = 1 - float(diff) * 0.05
	var points = diff + 9
	var dic = create_spread_settings(7, 0, 360, wait, points, 30, 0, 360, false)
	var spr = spread.instance()
	set_spread_settings(spr, dic)
	add_child(spr)
	
func add_shotgun_spread(diff):
	var wait =  5 + (float(diff) * -0.2)
	var points = diff + 4
	var size = 4 + diff
	var dic = create_spread_settings(20, 180-size, 180, wait, points, 30, 0, size, false)
	var spr = spread.instance()
	set_spread_settings(spr, dic)
	add_child(spr)

func add_barrage_spread(diff):
	var points = diff + 10
	var dic = create_spread_settings(1, 85, 95, 3, points, 30, 0, 180, false)
	var spr = spread.instance()
	set_spread_settings(spr, dic)
	add_child(spr)
	
func add_random_spread(diff):
	var wait = 3 / float(diff)
	var points = (diff + 7) / 2
	var dic = create_spread_settings(27, 0, 360, wait, points, 30, 0, 360, false)
	var spr = spread.instance()
	set_spread_settings(spr, dic)
	add_child(spr)
	
func set_spread_settings(spr: Node2D, dic : Dictionary):
	for k in dic.keys():
		spr.set(k, dic.get(k))
