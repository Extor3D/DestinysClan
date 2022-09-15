extends KinematicBody2D

export(float) var speed = 200
export(int) var health = 10
export(float) var cadence = 2
export(float) var vspeed = 0
export (int, 1, 100) var radius = 10

onready var sound = $AudioStreamPlayer2D
var shot_scene = preload("res://Enemies/Shots/EnemyShot.tscn")
var exp_effect : PackedScene = preload("res://Effects/Explosion.tscn")


export(float) var turn_speed = 2.7  # in radians/sec
export(float) var move_speed = 150  # pixels/sec

func _physics_process(delta):
	rotation +=turn_speed * delta
	move_and_collide(Vector2(-speed * delta, 0))
	move_and_collide(transform.x * move_speed * delta)

func _ready():
	$ShotTimer.start(cadence)

func take_damage(damage):
	#Add damage sound here
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
