extends Area2D

export(float) var speed = 150
export(int) var damage = 1

onready var tween = $Tween
onready var sprite = $Sprite

func _ready():
	tween.interpolate_property(sprite, "modulate", Color(1,1,1), Color(0,0,1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _physics_process(delta):
	sprite.global_rotation = 0
	position += transform.x * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_ChargeShot_body_entered(body):
	body.charge_energy(1)
	queue_free()
