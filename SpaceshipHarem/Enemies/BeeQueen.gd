extends KinematicBody2D

export(float) var speed = 200
export(int) var health = 10
export(int) var hold_x = 580
export(float) var cadence = 2
export(float) var vspeed = 0
var shot_scene = preload("res://Enemies/Enemy3.tscn")


export(float) var turn_speed = 0  # in radians/sec
export(float) var move_speed = 150  # pixels/sec

func _physics_process(delta):
	if position.x > hold_x:
		move_and_collide(Vector2(-speed * delta, 0))

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
