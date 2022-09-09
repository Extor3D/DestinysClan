extends KinematicBody2D

export(float) var speed = 150
export(float) var Yspeed = 50
export(int) var health = 500
export(int) var hold_x = 490
export(int) var hold_y = 100
export(int) var dificulty = 1

enum mutations {NONE = 1, EARTH = 2, WIND = 3, FIRE=4 , ICE=5}
export (mutations) var mutation = mutations.NONE

var sube = true
#corregir ajuste por dificultad?
export(float) var cadence = 1 - (0.1 * dificulty/2)
export(float) var vspeed = 0
var spawner_bee_scene = preload("res://Enemies/BeeSpawner.tscn")
var worber_bee_shot = preload("res://Enemies/Shots/EnemyShot.tscn")
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
	var bee_side = randf()
	var bee_modifier = 1
	# Para que lado giran las abejas
	if bee_side  > 0.50:
		bee_modifier = -1
	var shot = shot_scene.instance()
	if bee_type <  (0.45 +((10 -  dificulty) *  0.025)):
		shot.turn_speed = 0
		shot.shot_scene = worber_bee_shot
		print("disparadora")	
	else:
		print(bee_type)
		if (bee_type > (0.90 - (0.02 * (dificulty)))):
			shot.turn_speed = 10
			shot.speed = 1
			print("invocadora")	
		else:
			shot.turn_speed = 2.7 * bee_modifier
			print("giroteadora")	

			
			
	
	
	shot.position = p
	shot.rotation = PI
	#
	get_parent().add_child(shot)
