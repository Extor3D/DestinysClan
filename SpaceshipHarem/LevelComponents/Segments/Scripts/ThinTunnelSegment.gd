extends Segment

var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")

var lava_texture = preload("res://Scenery/Sprites/tile_lava.png")

# ver texturas
var earth_texture = preload("res://Scenery/Sprites/tile_earth.jpg")
var water_texture = preload("res://Scenery/Sprites/tile_water.png")
var steel_texture = preload("res://Scenery/Sprites/tile_other.png")

onready var timer = $SegmentTime

func start_segment():
	var time = 15 + difficulty * 2
	create_tunnel(time)
	timer.start(time)

func _on_SegmentTime_timeout():
	end_segment()

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
	tunnel.y = 180 
	tunnel.step_min = -30 - difficulty
	tunnel.step_max = 30 + difficulty
	tunnel.top_texture = earth_texture
	tunnel.bot_texture = water_texture
	tunnel.can_damage = true
	add_child(tunnel)
