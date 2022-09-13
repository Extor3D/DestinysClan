extends Segment

onready var timer = $SegmentTime

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
# Hive
var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")
var lava_texture = preload("res://Scenery/Sprites/tile_lava.png")

# Bee Enemies
var primary_enemy_scene = preload("res://Enemies/BeeEnemy.tscn")
var secondary_enemy_scene = preload("res://Enemies/BeeSpawner.tscn")
var tertiary_enemy_scene = preload("res://Enemies/Bosses/BeeQueen.tscn")

var spawners = []
var queen_dead = false

var rng = RandomNumberGenerator.new()

func start_segment():
	var time = 35 + difficulty * 2
	#spawners.append(add_bee_group(time,3,primary_enemy_scene))
	#spawners.append(add_bee_group(time/3,time/3,secondary_enemy_scene))
	#spawners.append(add_bee_group(2,time * 2/3,tertiary_enemy_scene))
	#create_tunnel(time/2)
	#Queen Test
	spawners.append(add_bee_group(2,0,tertiary_enemy_scene))
	
	timer.start(time)
	
func _on_SegmentTime_timeout():
	if (queen_dead):
		end_segment()
	
func _ready():
	rng.randomize()
	
func add_bee_group(duration,start,enemy):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = {"speed": 100 + difficulty*3,
				"cadence":100}
	if (enemy == secondary_enemy_scene):
		vars = {"speed": 30 + -difficulty*3,
				"turn_speed": rng.randi_range(2, 3),
				"cadence":2}
	#spawner.scene_variables = vars
	spawner.y_center = 20 + (60 * rand_range(0,4))
	spawner.height = 20 + (10* difficulty) 
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(1.35 - 0.2 * difficulty)
	add_child(spawner)
	return spawner


func create_tunnel(duration):
	var tunnel = tunnel_scene.instance()
	tunnel.type = VectorTunnel.types.BOTH
	tunnel.start_time = 0
	tunnel.duration = duration
	tunnel.new_vert_time = 1 / difficulty
	tunnel.tunnel_speed = 75 + difficulty * 3
	tunnel.tunnel_size = 150 - difficulty * 5
	tunnel.top = 100 
	tunnel.low = 260 
	tunnel.y = 50 
	tunnel.step_min = -30 - difficulty
	tunnel.step_max = 30 + difficulty
	tunnel.top_texture = lava_texture
	tunnel.bot_texture = lava_texture
	tunnel.can_damage = true
	add_child(tunnel)
