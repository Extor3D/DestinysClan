extends KinematicBody2D

export(float) var speed = 200
export(int) var health = 10
export(float) var cadence = 2
export(float) var vspeed = 0
var shot_scene = preload("res://Enemies/Shots/EnemyShot.tscn")


export(float) var turn_speed = 0   # in radians/sec  -2.7 to rotate
export(float) var move_speed = 100  # pixels/sec

func _physics_process(delta):
	rotation +=turn_speed * delta
	move_and_collide(Vector2(-speed * delta, 0))
	move_and_collide(transform.x * move_speed * delta)

func _ready():
	$ShotTimer.start(cadence)

func take_damage(damage):
	#Add damage sound here
	health -= damage
	if health <= 0:
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

func _process(_delta):
	if position.x < 0 || position.y < 0 || position.y > 600:
		queue_free()
