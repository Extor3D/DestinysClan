extends Node2D

enum types {OPEN = 1, HELL = 2}
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

var on_surface = true

var segments = []

onready var play_area = $PlayArea
onready var background = $BackGround
onready var timer = $BossTimer

#Background Scenes
var space_scene = preload("res://LevelComponents/SpaceBackground.tscn")
var planet_scene = preload("res://Generators/World/PlanetGenerator.tscn")
var open_surf_scene = preload("res://Scenery/Backgrounds/OpenSurface/OnSurfOpen.tscn")

#Segments
var thin_tunnel_segment = preload("res://LevelComponents/Segments/ThinTunnelSegment.tscn")
var asteroid_segment = preload("res://LevelComponents/Segments/DeepSpaceSegment.tscn")
var trafficjam_segment = preload("res://LevelComponents/Segments/TrafficJamSegment.tscn")
var DeepSpace_Segment = preload("res://LevelComponents/Segments/DeepSpaceSegment.tscn")

var random_boss_scene = preload("res://Enemies/Bosses/RandomBoss.tscn")

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

#var possible_segments = [thin_tunnel_segment, asteroid_segment,trafficjam_segment]
var possible_segments = [DeepSpace_Segment,trafficjam_segment]
func _ready():
	rng.randomize()
	calculate_times()
	on_surface = rng.randf() < 0.5
	create_background(on_surface, theme)
	match type:
		types.OPEN:
			create_open_level()
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
		var planet = planet_scene.instance()
		planet.theme = theme
		planet.size = 2000
		planet.global_position = Vector2(-675, 300)
		background.add_child(planet)
		background.add_child(space_back)
	else:
		if theme == themes.NONE:
			var back = open_surf_scene.instance()
			background.add_child(back)
		
		
func create_open_level():
	for i in 2:
		# To test a segment, use this line and comment the "possible_segments" line
		# Remember to declare the scene at the top of this file
		# var s = <your_scene>
		var s = possible_segments.pop_at(rng.randi_range(0, possible_segments.size() - 1))
		var seg = s.instance()
		seg.difficulty = difficulty
		seg.number = i + 1
		seg.connect("segment_ended", self, "next_segment")
		segments.append(seg)
		play_area.add_child(seg)
		
	segments[0].start_segment()
	
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
	
func spawn_boss():
	var boss = random_boss_scene.instance()
	boss.position = Vector2(700, 180)
	boss.health = 100 + 20 * difficulty
	boss.difficulty = difficulty
	play_area.add_child(boss)
	
func next_segment(n):
	if segments.size() <= n:
		timer.start(5)
	else:
		segments[n].start_segment()

