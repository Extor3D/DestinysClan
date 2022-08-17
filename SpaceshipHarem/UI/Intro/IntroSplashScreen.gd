extends Node2D

onready var ludover_logo = $LudoverLogo
onready var destiny_logo = $Logo
onready var blend_tween = $BlendOut
onready var wait_timer = $LogoWaitTime

var step = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LogoWaitTime_timeout():
	if step == 4:
		step = 5
		blend_tween.interpolate_property(ludover_logo, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		blend_tween.start()
	
	if step == 1:
		step = 2
		blend_tween.interpolate_property(destiny_logo, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		blend_tween.start()


func _on_BlendOut_tween_all_completed():
	if step == 5:
		next()
	
	if step == 3:
		wait_timer.start()
		step = 4
	
	if step == 2:
		blend_tween.interpolate_property(ludover_logo, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		blend_tween.start()
		step = 3
	
func next():
	Global.goto_scene("res://UI/Screens/MainMenu.tscn")
	
