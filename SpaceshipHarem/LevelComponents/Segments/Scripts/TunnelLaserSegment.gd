extends Segment

var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")
var laser : PackedScene = preload("res://Enemies/Shots/LaserShot.tscn")

var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()

var lava_texture = preload("res://Scenery/Sprites/tile_lava.png")

# ver texturas
var earth_texture = preload("res://Scenery/Sprites/tile_earth.jpg")
var water_texture = preload("res://Scenery/Sprites/tile_water.png")
var steel_texture = preload("res://Scenery/Sprites/tile_other.png")
	

onready var timer = $SegmentTime
onready var laser_timer = $LaserSpawnTimer

var rng = RandomNumberGenerator.new()

var l_size = 10
var l_time = 1
var warn_time = 1

# Label interactions
var SEGMENT_TEXTS = ["Doble Amenaza detectada. Lasers y Camino Angosto.","Alpha: Omega, tengamos cuidado."]
const Char_Alpha = 	Global.Char_Alpha
const Char_Omega = 	Global.Char_Omega
const Char_Kokoro = Global.Char_Kokoro
const Char_Dummy = 	Global.Char_Dummy

var Chars_Speaking = [Char_Dummy,Char_Alpha]

func start_segment():
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
	var time = 15 + difficulty * 2
	create_tunnel(time)
	rng.randomize()
	var laser_time = 2 - float(difficulty)/25
	l_size = 10
	l_time = 1.5 + difficulty * 0.1
	timer.start(time)
	laser_timer.start(laser_time)

func create_tunnel(duration):
	var tunnel = tunnel_scene.instance()
	tunnel.type = VectorTunnel.types.BOTH
	tunnel.start_time = 0
	tunnel.duration = duration
	tunnel.new_vert_time = 1 / difficulty
	tunnel.tunnel_speed = 75 + difficulty * 3
	tunnel.tunnel_size = 180 - difficulty * 5
	tunnel.top = 100 
	tunnel.low = 260 
	tunnel.y = 180 
	tunnel.step_min = -30 - difficulty
	tunnel.step_max = 30 + difficulty
	tunnel.top_texture = lava_texture
	tunnel.bot_texture = lava_texture
	tunnel.can_damage = true
	add_child(tunnel)

func _on_SegmentTime_timeout():
	laser_timer.stop()
	remove_child(label)
	end_segment()

func _on_LaserSpawnTimer_timeout():
	var l = laser.instance()
	l.global_position = Vector2(rng.randi_range(30, 780), -100)
	l.size = l_size
	l.rotation_degrees = 110
	var t = get_tree().create_timer(l_time)
	t.connect("timeout", l, "deactivate")
	add_child(l)
