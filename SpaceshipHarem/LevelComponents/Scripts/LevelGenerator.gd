extends Node2D

enum types {OPEN = 1, TUNNEL = 2, HELL = 3}

export (types) var type
export (int) var difficulty

var rng = RandomNumberGenerator.new()

var base_time = 20
var part_duration
var mid_start
var end_start
var finish
var interlude_time = 5


#Components Scenes
var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var swarmer_scene = preload("res://LevelComponents/Segments/SwarmSegment.tscn")

#Enemy Scene
var enemy_scene = preload("res://Enemies/Enemy.tscn")

func _ready():
	rng.randomize()
	calculate_times()
	match type:
		types.OPEN:
			create_open_level()
		types.TUNNEL:
			create_tunnel_level()
		types.HELL:
			pass
			
func calculate_times():
	part_duration = base_time + difficulty
	mid_start = part_duration
	end_start = mid_start + interlude_time + part_duration
	finish = end_start + interlude_time + part_duration
	
func create_open_level():
	add_swarm($Start, 0, part_duration)

func create_tunnel_level():
	create_tunnel(0, VectorTunnel.NO_END, VectorTunnel.types.BOTH)
	create_start_part($Start)
	
func create_start_part(start):
	create_spawner(start, 0, part_duration)
	
func create_spawner(part, start, duration):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy_scene
	var vars = {"speed": 60 + difficulty*5,
				"health": 1}
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 80
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(4.35 - 0.35 * difficulty)
	part.add_child(spawner)

func create_tunnel(start, duration, type):
	var tunnel = tunnel_scene.instance()
	tunnel.type = type
	tunnel.start_time = start
	tunnel.duration = duration
	tunnel.new_vert_time = 1 / difficulty
	tunnel.tunnel_speed = 50 + difficulty*5
	tunnel.tunnel_size = 200 - difficulty*10
	tunnel.top = 100 + rng.randi_range(-50, 20)
	tunnel.low = 260 + rng.randi_range(-20, 50)
	tunnel.y = 180 + rng.randi_range(-50, 50)
	tunnel.step_min = rng.randi_range(-50, -10)
	tunnel.step_max = rng.randi_range(50, 10)
	tunnel.top_texture
	tunnel.bot_texture
	$Start.add_child(tunnel)

func add_swarm(part, start, duration):
	var swarmer = swarmer_scene.instance()
	swarmer.scene = enemy_scene
	var vars = {"speed": 300 + difficulty*20,
				"health": 1}
	swarmer.scene_variables = vars
	swarmer.waves = difficulty+2
	swarmer.rows = difficulty+5/2
	swarmer.start = start
	swarmer.duration = duration
	swarmer.wait = 1/difficulty
	part.add_child(swarmer)
