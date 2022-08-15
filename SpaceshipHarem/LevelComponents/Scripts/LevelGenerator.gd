extends Node2D

enum types {OPEN = 1, TUNNEL = 2, HELL = 3}
enum themes {NONE = 1, FIRE = 2, ICE = 3}

export (types) var type = types.OPEN
export (themes) var theme = themes.NONE
export (int, 1, 10) var difficulty = 1

var rng = RandomNumberGenerator.new()

var base_time = 20
var part_duration
var mid_start
var end_start
var finish
var interlude_time = 5

var on_surface = false

var segments = []

onready var play_area = $PlayArea
onready var background = $BackGround

#Background Scenes
var space_scene = preload("res://LevelComponents/SpaceBackground.tscn")

#Segments
var thin_tunnel_segment = preload("res://LevelComponents/Segments/ThinTunnelSegment.tscn")

#Components Scenes
var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var swarmer_scene = preload("res://LevelComponents/SwarmSegment.tscn")

#Objects Scenes
export (PackedScene) var enemy_scene = preload("res://Enemies/Enemy.tscn")
export (PackedScene) var secondary_scene = preload("res://Enemies/Enemy.tscn")
export (PackedScene) var tertiary_scene = preload("res://Enemies/Enemy.tscn")
var bullet_hell_scene = preload("res://Enemies/BulletHellEnemy.tscn")
var obstacle_scene = preload("res://Scenery/Obstacle.tscn")

func _ready():
	rng.randomize()
	calculate_times()
	on_surface = not randi() % 2
	create_background(on_surface, theme)
	match type:
		types.OPEN:
			create_open_level()
		types.TUNNEL:
			create_tunnel_level()
		types.HELL:
			create_hell_level()
			
func calculate_times():
	part_duration = base_time + difficulty
	mid_start = part_duration
	end_start = mid_start + interlude_time + part_duration
	finish = end_start + interlude_time + part_duration
	
func create_background(on_srfce: bool, t: int):
	if not on_srfce:
		var space_back = space_scene.instance()
		space_back.type = t
		background.add_child(space_back)
		
func create_open_level():
	var seg1 = thin_tunnel_segment.instance()
	seg1.difficulty = difficulty
	segments.append(seg1)
	var seg2 = thin_tunnel_segment.instance()
	seg2.difficulty = difficulty
	segments.append(seg2)
	var seg3 = thin_tunnel_segment.instance()
	seg3.difficulty = difficulty
	segments.append(seg3)
	play_area.add_child(seg3)
	seg2.next_segment = seg3.get_path()
	play_area.add_child(seg2)
	seg1.next_segment = seg2.get_path()
	play_area.add_child(seg1)
	seg1.start_segment()

func create_tunnel_level():
	create_tunnel(0, VectorTunnel.NO_END, VectorTunnel.types.BOTH)
	create_start_part($PlayArea)
	
func create_hell_level():
	var spawner1 = add_hell_sub_boss(true)
	var spawner2 = add_hell_sub_boss(false)
	spawner1.connect("spawner_cleared", spawner2, "start_timer")
	var spawner3 = add_hell_sub_boss(false)
	spawner2.connect("spawner_cleared", spawner3, "start_timer")
	
func add_hell_sub_boss(on_ready):
	var spawner = spawner_scene.instance()
	spawner.scene = bullet_hell_scene
	var vars = {"speed": 100,
				"health": 50 + difficulty * 10,
				"difficulty": difficulty }
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 1
	spawner.start_time = 0
	spawner.duration = 1
	spawner.warning = false
	spawner.set_wait_time(0.8)
	spawner.start_on_ready = on_ready
	play_area.add_child(spawner)
	return spawner
	
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

func create_tunnel(start, duration, t):
	var tunnel = tunnel_scene.instance()
	tunnel.type = t
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
	$PlayArea.add_child(tunnel)

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
	
func add_asteroid_field(part, start, duration):
	var spawner = spawner_scene.instance()
	spawner.scene = obstacle_scene
	var vars = {"speed": -30 + -difficulty*3,
				"rot_spd": rng.randi_range(-3, 3)}
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 180
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(4.35 - 0.35 * difficulty)
	part.add_child(spawner)
