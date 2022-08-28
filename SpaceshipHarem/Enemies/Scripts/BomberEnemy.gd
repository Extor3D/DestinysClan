extends KinematicBody2D

export(float) var speed = 100
export(int) var health = 10
export(float) var cadence = 1

onready var sound = $AudioStreamPlayer2D
onready var timer = $BombTimer

var rng = RandomNumberGenerator.new()
var bomb_scene = preload("res://Enemies/Weapons/EnemyBomb.tscn")

func _physics_process(delta):
	move_and_collide(Vector2(-speed * delta, 0))

func _ready():
	rng.randomize()
	timer.start(cadence)

func take_damage(damage):
	sound.play()
	health -= damage
	if health <= 0:
		queue_free()

func _on_BombTimer_timeout():
	create_bomb(global_position - Vector2($Sprite.texture.get_width()/2, 0))
	
func create_bomb(p: Vector2):
	var bomb = bomb_scene.instance()
	bomb.position = p
	bomb.radius = 40
	bomb.final_pos = Vector2(rng.randi_range(10, 630), rng.randi_range(10, 350))
	get_parent().add_child(bomb)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
