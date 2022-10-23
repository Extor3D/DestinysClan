extends Area2D

export(float) var speed = 150
export(int) var damage = 1

onready var tween = $Tween
onready var sprite = $Sprite

var explosion = preload("res://Effects/Explosion.tscn")

func _ready():
	tween.interpolate_property(sprite, "modulate:s", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _physics_process(delta):
	sprite.global_rotation = 0
	position += transform.x * speed * delta

func _on_EnemyShot_body_entered(body):
	var e = explosion.instance()
	e.size = 20
	e.global_position = global_position
	get_tree().root.get_child(0).add_child(e)
	body.take_damage(damage)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
