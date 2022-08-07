extends Timer

signal spawner_cleared

export (PackedScene) var scene
export (Dictionary) var scene_variables
export (int) var y_center = 180
export (int) var height = 80
export (float) var start_time = 0
export (float) var duration = 5
export (bool) var warning = false
export (bool) var start_on_ready = true
var rng = RandomNumberGenerator.new()

var ended = false

func _ready():
	rng.randomize()
	set_paused(true)
	if start_on_ready:
		start_timer()
	$WarningSign.visible = false
	$WarningSign.global_position = Vector2(600, y_center)
	$WarningSign.scale = Vector2(height/float(50), height/float(50))
	
func start_timer():
	$StartTime.start(start_time)
	
func _on_EnemyTimer_timeout():
	#Create a new enemy in the specified range
	if scene != null:
		var e = scene.instance()
		for k in scene_variables.keys():
			e.set(k, scene_variables.get(k))
		e.global_position = Vector2(get_viewport().size.x + 10, rng.randi_range(y_center - height, y_center + height))
		$CleanWhenOut.add_child(e)

func _process(_delta):
	#Loop all the nodes in CleanWhenOut
	for c in $CleanWhenOut.get_children():
		if c is Node2D and c.global_position.x < -50:
			#Remove the node if it leaves the screen from the left
			c.queue_free()
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
