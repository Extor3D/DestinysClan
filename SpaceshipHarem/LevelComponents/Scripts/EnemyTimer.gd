extends Timer

signal spawner_cleared

#---Spawner Scene---
#This scene creates an area where it can spawn certain other scenes at a
#fixed intervals, when it's set to start and lasts a certain duration.
#

export (PackedScene) var scene				#Scene to spawn
export (Dictionary) var scene_variables		#Dictonary of variables to set to each spawned scene
export (int) var y_center = 180				#Center of the spawn area Y coordinate
export (int) var x_center = 740				#Center of the spawn area X coordinate
export (int) var height = 80				#Height from the center to the top of the area, this is also repeated downwards
export (int) var width = 40					#Length from the center to the right of the area, this is also repeated leftwards
export (float) var start_time = 0			#Time in seconds when the spawner starts
export (float) var duration = 5				#Time in seconds the spawn lasts
export (bool) var warning = false			#Shows a warning sign in the border when the spawner activates
export (bool) var start_on_ready = true		#Set to true to start the spawner whenever it's created, if false, it can be started with "start_timer()"
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
