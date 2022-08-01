extends KinematicBody2D

export(float) var speed = 150
export(float) var Yspeed = 50
export(int) var health = 1000
export(int) var hold_x = 490
export(int) var hold_y = 100
var sube = true
export(float) var cadence = 0.5
export(float) var vspeed = 0
var spawner_bee_scene = preload("res://Enemies/Enemy3.tscn")
var worber_bee_shot = preload("res://Enemies/EnemyShot.tscn")
var shot_scene = spawner_bee_scene

export(float) var turn_speed = 0  # in radians/sec

func _physics_process(delta):
	if position.y >  260:
		sube = true
	elif position.y <  hold_y:
		sube = false
		
	if position.x > hold_x:
		move_and_collide(Vector2(-speed * delta, 0))
	else:
		if sube && position.x <= hold_x && position.y >= hold_y:
			move_and_collide(Vector2(0, -Yspeed * delta))
		elif !sube && position.x <= hold_x && position.y <=  hold_y + 200:
			move_and_collide(Vector2(0, Yspeed * delta))

func _ready():
	$ShotTimer.start(cadence)

func take_damage(damage):
	#Add damage sound here
	health -= damage
	if health <= 0:
		queue_free()

func _on_ShotTimer_timeout():
	#Add shotting sound here
	if position.x <= hold_x:
		create_shot(global_position - Vector2($Sprite.texture.get_width()/2, 0))
	
func create_shot(p: Vector2):
	var bee_type = randf()
	var shot = shot_scene.instance()
	if bee_type < 0.75:
		shot.turn_speed = 0
		shot.shot_scene = worber_bee_shot
	else:
		shot.turn_speed = 0.3
		if bee_type <0.90:
			shot.turn_speed = -2.7
			
	
	
	shot.position = p
	shot.rotation = PI
	#
	get_parent().add_child(shot)
