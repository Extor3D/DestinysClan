extends Node2D

export(int, 1, 100) var size = 1

onready var warning_line = $WarningLine
onready var warning_back = $WarningLineBack
onready var warning_timer = $WarningTime

onready var rc = $RayCast2D
onready var line = $RayCast2D/Line2D
onready var tween = $RayCast2D/Tween
onready var cast_particles = $RayCast2D/CastingParticles
onready var col_particles = $RayCast2D/CollisionParticles
onready var beam_particles = $RayCast2D/BeamParticles

var on = false

func _ready():
	line.hide()
	warning_line.scale = Vector2(1, size)
	warning_back.scale = Vector2(1, size)
	line.scale = Vector2(1, size)
	var w_color = Global.WARNING_COLOR
	w_color.a = 0.3
	warning_line.default_color = Global.WARNING_COLOR
	warning_back.default_color = w_color
	warning_appear()
	set_physics_process(false)

func deactivate():
	queue_free()
	
func _physics_process(_delta):
	if on:
		ray()
		
	
func _on_WarningTime_timeout():
	line.show()
	set_on(true)
	warning_line.hide()
	warning_back.hide()

func ray():
	var cast_point = rc.cast_to
	rc.force_raycast_update()
	
	col_particles.emitting = rc.is_colliding()
	if rc.is_colliding():
		rc.get_collider().take_damage(1)
		cast_point = rc.to_local(rc.get_collision_point())
		col_particles.global_rotation = rc.get_collision_normal().angle()
		col_particles.position = cast_point
		
	line.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_on(cast: bool):
	on = cast
	beam_particles.emitting = on
	cast_particles.emitting = on
	if on:
		appear()
	else:
		col_particles.emitting = false
		disappear()
	set_physics_process(on)
	
func warning_appear():
	tween.stop_all()
	tween.interpolate_property(warning_line, "width", 0, 1, 1)
	tween.start()

func appear():
	tween.stop_all()
	tween.interpolate_property(line, "width", 0, 1, 0.2)
	tween.start()
	

func disappear():
	tween.stop_all()
	tween.interpolate_property(line, "width", 1, 0, 0.1)
	tween.start()
