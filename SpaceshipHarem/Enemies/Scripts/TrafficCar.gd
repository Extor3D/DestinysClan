extends KinematicBody2D

export(float) var speed = 100
export(int) var health = 1000
# Cadence time the honks
export(float) var cadence = 2
export(float) var color = 2
export(float) var driver = "Sunday Driver"

var shot_scene = preload("res://Enemies/Shots/EnemyShot.tscn")

func _physics_process(delta):
	move_and_collide(Vector2(-speed * delta, 0))

func _ready():
	$ShotTimer.start(cadence)
	var rot = 1


func take_damage(damage):
	#Add damage sound here
	health -= damage
	if health <= 0:
		queue_free()

func _on_ShotTimer_timeout():
	#Add shotting sound here
	#create_shot(global_position - Vector2($Sprite.texture.get_width()/2, 0))
	pass
	
func create_shot(p: Vector2):
	var shot = shot_scene.instance()
	shot.position = p
	shot.rotation = PI
	get_parent().add_child(shot)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
