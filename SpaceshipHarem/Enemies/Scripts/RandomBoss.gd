extends KinematicBody2D

export(float) var speed = 100
export(int) var health = 100
export(int) var hold_x = 580
export(int, 1, 10) var difficulty = 1

var weapons : Array = []
var normal_bullet : PackedScene = preload("res://Enemies/Shots/EnemyShot.tscn")
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
	var spr = spread.instance()
	spr.set_spread(wpn, diff)
	add_child(spr)
