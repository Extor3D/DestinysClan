extends Node2D

export (PackedScene) var scene
export (Dictionary) var scene_variables
export (float) var start = 0
export (float) var duration = 10
export (float) var wait = 1
export (int) var waves = 3
export (int) var rows = 3
export (int) var top = 0
export (int) var bot = 360

var rng = RandomNumberGenerator.new()

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var wave_dur = duration / waves
	var size = (bot - top) / rows
	var y = top + size * rng.randi_range(1, rows) - size/2
	for i in waves:
		create_spawner(start + i * wave_dur, wave_dur - wait, scene, scene_variables, y, size/2)
		y = top + size * rng.randi_range(1, rows) - size/2
	
func create_spawner(start, duration, scene, variables, y, h):
	var spawner = spawner_scene.instance()
	spawner.scene = scene
	spawner.scene_variables = variables
	spawner.y_center = y
	spawner.height = h
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = true
	spawner.set_wait_time(0.1)
	add_child(spawner)
