extends Segment

var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/SpecieEnemy.tscn")
var lava_texture = preload("res://Scenery/Sprites/tile_lava.png")

# ver texturas
var earth_texture = preload("res://Scenery/Sprites/tile_earth.jpg")

onready var timer = $SegmentTime
var rng = RandomNumberGenerator.new()

func start_segment():
	var time = 20 + difficulty * 2
	create_tunnel(time,0)
	#create_tunnel(time/2,time/2)
	add_enemy_group(time,3,primary_enemy_scene,1)
	timer.start(time)

func _on_SegmentTime_timeout():
	end_segment()

func create_tunnel(duration,start):
	var tunnel = tunnel_scene.instance()
	tunnel.type = VectorTunnel.types.BOTH
	tunnel.start_time = start
	tunnel.duration = duration
	tunnel.new_vert_time = 1 / difficulty
	tunnel.tunnel_speed = 75 + difficulty * 3
	tunnel.tunnel_size = 200 - difficulty * 5
	tunnel.top = 100 
	tunnel.low = 360 
	tunnel.y = 180 
	tunnel.step_min = -30 - difficulty
	tunnel.step_max = 30 + difficulty
	#tunnel.top_texture = lava_texture
	#tunnel.bot_texture = lava_texture
	tunnel.can_damage = false
	add_child(tunnel)
	
func add_enemy_group(duration,start,enemy,variation):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars
	if variation == 1:
		vars = {"speed": 70 + difficulty*3,
					"cadence":2}
	else:
		vars = {"speed": 170 + difficulty*3,
					"cadence":4}
	spawner.scene_variables = vars
	spawner.y_center = 180 
	#20 + (60 * rand_range(0,4))
	spawner.height = 25 + (10* difficulty) 
	spawner.start_time = start
	spawner.duration = duration -2
	spawner.warning = false
	spawner.set_wait_time(1.35 - 0.1 * difficulty)
	add_child(spawner)
	return spawner
