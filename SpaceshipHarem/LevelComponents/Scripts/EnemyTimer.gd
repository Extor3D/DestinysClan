extends Timer

signal spawner_cleared

export (PackedScene) var scene
export (Dictionary) var scene_variables
export (int) var y_center = 180
export (int) var x_center = 740
export (int) var height = 80
export (int) var width = 40
export (float) var start_time = 0
export (float) var duration = 5
export (bool) var warning = false
export (bool) var start_on_ready = true
var rng = RandomNumberGenerator.new()

var ended = false
var margin = 40

func _ready():
	rng.randomize()
	set_paused(true)
	if start_on_ready:
		start_timer()
	$WarningSign.visible = false
	var warn_pos = Vector2(clamp(x_center, margin, get_viewport().size.x - margin), clamp(y_center, margin, get_viewport().size.y - margin))		
	$WarningSign.global_position = warn_pos
	$WarningSign.scale = Vector2(height/float(50), height/float(50))
	
func start_timer():
	$StartTime.start(start_time)
	
func _on_EnemyTimer_timeout():
	#Create a new enemy in the specified range
	if scene != null:
		var e = scene.instance()
		for k in scene_variables.keys():
			e.set(k, scene_variables.get(k))
		e.global_position = Vector2(rng.randi_range(x_center - width, x_center + width), rng.randi_range(y_center - height, y_center + height))
		$CleanWhenOut.add_child(e)

func _process(_delta):
	if $CleanWhenOut.get_child_count() == 0 and ended:
		emit_signal("spawner_cleared")
		queue_free()

func _on_EndTime_timeout():
	#Stops the spawner when duration timeouts
	ended = true
	set_paused(true)
	if warning:
		$WarningSign.visible = false

func _on_StartTime_timeout():
	#Starts the spawner when the start timer timeouts
	set_paused(false)
	$WarningSign.visible = warning
	if duration > 0:
		$EndTime.start(duration)
