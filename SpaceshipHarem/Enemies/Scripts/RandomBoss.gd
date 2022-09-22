extends KinematicBody2D

signal defeated

export(float) var speed = 100
export(int) var health = 100
export(int) var hold_x = 580
export(int, 1, 10) var difficulty = 1

var sprite_count = 7
var sprite_path_start = "res://Enemies/Sprites/Bosses/Boss_"
var sprite_path_end = ".png"

var normal_bullet : PackedScene = preload("res://Enemies/Shots/EnemyShot.tscn")
var spread : PackedScene = preload("res://Enemies/Weapons/SpreadWeapon.tscn")
var laser : PackedScene = preload("res://Enemies/Weapons/LaserWeapon.tscn")
var max_health = 100

var circular_path : PackedScene = preload("res://Enemies/MovementTypes/CircularPath.tscn")

onready var boss_sprite = $Sprite

var rng = RandomNumberGenerator.new()
var path

func _ready():
	rng.randomize()
	var spr_tex = load(sprite_path_start + str(rng.randi_range(1, sprite_count)) + sprite_path_end)
	boss_sprite.texture = spr_tex
	add_weapon(spread, rng.randi_range(1, 6), difficulty)
	add_weapon(spread, rng.randi_range(1, 6), difficulty)
	add_weapon(laser, rng.randi_range(1, 2), difficulty)
	if difficulty > 5:
		add_weapon(spread, rng.randi_range(1, 6), difficulty - 3)
	add_path()
	max_health = health

func _physics_process(delta):
	if position.x > hold_x:
		move_and_collide(Vector2(-speed * delta, 0))
	elif not path.enabled:
		path.enable()

func take_damage(damage):
	#Add damage sound here
	health -= damage
	if health <= 0:
		emit_signal("defeated")
		queue_free()
		
func add_weapon(scn, wpn, diff):
	var spr = scn.instance()
	spr.set_spread(wpn, diff)
	add_child(spr)
	
func add_path():
	path = circular_path.instance()
	add_child(path)
