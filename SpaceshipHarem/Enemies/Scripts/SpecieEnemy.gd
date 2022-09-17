extends KinematicBody2D

export(float) var speed = 100
export(int) var health = 10
export(float) var cadence = 2
export (int, 1, 100) var radius = 10

onready var sound = $AudioStreamPlayer2D
onready var sprite = $Sprite
var shot_scene = preload("res://Enemies/Shots/EnemyShot.tscn")
var exp_effect : PackedScene = preload("res://Effects/Explosion.tscn")

var android_sprite = preload("res://Player/Sprites/Races/android_ship.png")
var cat_sprite = preload("res://Player/Sprites/Races/cat_ship.png")
var human_sprite = preload("res://Player/Sprites/Races/human_ship.png")
var martian_sprite = preload("res://Player/Sprites/Races/martian_ship.png")
var diablo_sprite = preload("res://Player/Sprites/Races/diablo_ship.png")
var dummy_sprite = preload("res://Player/Sprites/Races/dummy_ship.png")

func _physics_process(delta):
	move_and_collide(Vector2(-speed * delta, 0))

func _ready():
	$ShotTimer.start(cadence)
	if cadence == 2:
		sprite.texture = cat_sprite

func take_damage(damage):
	sound.play()
	health -= damage
	if health <= 0:
		var eff = exp_effect.instance()
		eff.global_position = self.global_position
		eff.size = radius * 2
		get_tree().root.get_child(0).add_child(eff)
		queue_free()

func _on_ShotTimer_timeout():
	#Add shotting sound here
	create_shot(global_position - Vector2($Sprite.texture.get_width()/2, 0))
	
func create_shot(p: Vector2):
	var shot = shot_scene.instance()
	shot.position = p
	shot.rotation = PI
	get_parent().add_child(shot)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
