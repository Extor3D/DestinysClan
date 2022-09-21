extends Node2D

signal new_segment(number)
signal boss_spawned(boss)

export (Global.themes) var theme = Global.themes.LAND
export (int, 1, 10) var difficulty = 1

var rng = RandomNumberGenerator.new()

var on_surface = true

var segments = []

onready var player = $Player
onready var play_area = $PlayArea
onready var background = $BackGround
onready var timer = $BossTimer
onready var music = $BackgroundMusic
onready var tween = $Tween

# Special Background Music
var tutorial_music = preload("res://Music/Levels/pixel-perfect-tutorial.mp3")

# Level Background Music
var dangerous_music = preload("res://Music/Levels/kim-lightyear-legends.mp3")
var exploration_music = preload("res://Music/Levels/kim-lightyear-angel-eyes.mp3")
var mysterious_music = preload("res://Music/Levels/chiptune-c64.mp3")
var chill_music = preload("res://Music/Levels/chilliwave-evolving-space.mp3")
var action_music = preload("res://Music/Levels/confuze.mp3")
var dark_music = preload("res://Music/Levels/dark-future.mp3")
var beat_music = preload("res://Music/Levels/faster-tan-light.mp3")

#Boss Background Music
var boss_music = preload("res://Music/Boss/angrymod.mp3")
var boss_music2 = preload("res://Music/Boss/robot-laser-carnage.mp3")
var boss_music3 = preload("res://Music/Boss/star-war.mp3")

#Background Scenes
var space_scene = preload("res://LevelComponents/SpaceBackground.tscn")
var planet_scene = preload("res://Generators/World/PlanetGenerator.tscn")
var open_surf_scene = preload("res://Scenery/Backgrounds/OpenSurface/OnSurfOpen.tscn")
var ice_surf_scene = preload("res://Scenery/Backgrounds/IceSurface/IceSurfaceBackground.tscn")
var fire_surf_scene = preload("res://Scenery/Backgrounds/FireSurface/FireSurfaceBackground.tscn")

#Segments
var thin_tunnel_segment = preload("res://LevelComponents/Segments/ThinTunnelSegment.tscn")
var enemy_tunnel_segment = preload("res://LevelComponents/Segments/EnemyTunnelSegment.tscn")
var asteroid_segment = preload("res://LevelComponents/Segments/AsteroidSegment.tscn")
var bee_hive_segment = preload("res://LevelComponents/Segments/BeeHiveSegment.tscn")
var trafficjam_segment = preload("res://LevelComponents/Segments/TrafficJamSegment.tscn")
var deep_space_segment = preload("res://LevelComponents/Segments/DeepSpaceSegment.tscn")
var bomb_shower_segment = preload("res://LevelComponents/Segments/BombShowerSegment.tscn")
var bomber_segment = preload("res://LevelComponents/Segments/BomberEnemiesSegment.tscn")
var sub_boss_segment = preload("res://LevelComponents/Segments/SubBossSegment.tscn")
var laser_shower_segment = preload("res://LevelComponents/Segments/LaserShowerSegment.tscn")
var tunnel_laser_segment = preload("res://LevelComponents/Segments/TunnelLaserSegment.tscn")

#Tutorial
var tutorial1 = preload("res://LevelComponents/Segments/Tutorial/Tutorial1Segment.tscn")
var tutorial2 = preload("res://LevelComponents/Segments/Tutorial/Tutorial2Segment.tscn")
var tutorial3 = preload("res://LevelComponents/Segments/Tutorial/Tutorial3Segment.tscn")

var random_boss_scene = preload("res://Enemies/Bosses/RandomBoss.tscn")

var tutorial_segments = [tutorial2,tutorial3,tutorial1]

var possible_segments = [thin_tunnel_segment, 
						asteroid_segment, 
						trafficjam_segment,
						deep_space_segment,
						bomb_shower_segment,
						bomber_segment,
						sub_boss_segment,
						laser_shower_segment,
						enemy_tunnel_segment,
						tunnel_laser_segment
]

						
var possible_musics = [dangerous_music,exploration_music,mysterious_music]

var boss = null

func _ready():
	rng.randomize()
	on_surface = rng.randf() < 0.5
	difficulty = Global.current_difficulty
	theme = Global.current_theme
	create_background(on_surface)
	create_level()
	if Global.level != 0:
		music.stream = possible_musics[rng.randi_range(0, possible_musics.size() - 1)]
	else:
		music.stream = tutorial_music
	music.play()
	player.connect("game_over", self, "game_over_animation")
			
func create_background(on_srfce: bool):
	if not on_srfce:
		var space_back = space_scene.instance()
		space_back.theme = theme
		var planet = planet_scene.instance()
		planet.theme = theme
		planet.size = 2000
		planet.global_position = Vector2(-675, 300)
		background.add_child(planet)
		background.add_child(space_back)
	else:
		match theme:
			Global.themes.LAND:
				var back = open_surf_scene.instance()
				background.add_child(back)
			Global.themes.ICE:
				var back = ice_surf_scene.instance()
				background.add_child(back)
			Global.themes.FIRE:
				var back = fire_surf_scene.instance()
				background.add_child(back)
		
func create_level():
	for i in 3:
		var s
		#'''
		if Global.level == 0:
			# Pantalla de Skip Tutorial o ...
			s = tutorial_segments[i-1]
		else:
			s = possible_segments.pop_at(rng.randi_range(0, possible_segments.size() - 1))
		#'''
		
		# To test a segment, use this line.
		# Remember to declare the scene at the top of this file
		# s = <scene>
		var seg = s.instance()

		seg.difficulty = difficulty
		seg.number = i + 1
		seg.connect("segment_ended", self, "next_segment")
		segments.append(seg)
		play_area.add_child(seg)
		
	segments[0].start_segment()
	
func spawn_boss():
	music.stop()
	music.stream = boss_music
	music.play()
	boss = random_boss_scene.instance()
	boss.position = Vector2(700, 180)
	boss.health = 100 + 20 * difficulty
	boss.difficulty = difficulty
	play_area.add_child(boss)
	boss.connect("defeated", self, "end_level")
	emit_signal("boss_spawned", boss)
	
func game_over_animation():
	Engine.time_scale = 0.01
	yield(get_tree().create_timer(0.02), "timeout")
	tween.interpolate_property(Engine, "time_scale", 0.1, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
func next_segment(n):
	if n >= segments.size():
		timer.start(5)
	else:
		segments[n].start_segment()
	emit_signal("new_segment", n)
	
func end_level():
	music.stop()
	yield(get_tree().create_timer(3.0), "timeout")
	if Global.level == 0:
		Global.current_difficulty = 0
		Global.goto_scene("res://UI/Screens/LevelSelect.tscn")
	elif Global.level > 3:
		Global.goto_scene("res://UI/Screens/Victory.tscn")
	else:
		Global.goto_scene("res://UI/Screens/PilotSelect.tscn")
		
func _on_Tween_tween_all_completed():
	Global.goto_scene("res://UI/Screens/Game Over.tscn")
