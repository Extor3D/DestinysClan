extends Segment

var tunnel_scene = preload("res://LevelComponents/VectorTunnel.tscn")

var lava_texture = preload("res://Scenery/Sprites/tile_lava.png")

# ver texturas
var earth_texture = preload("res://Scenery/Sprites/tile_earth.jpg")
var water_texture = preload("res://Scenery/Sprites/tile_water.png")
var steel_texture = preload("res://Scenery/Sprites/tile_other.png")

var label_scene = preload("res://UI/Screens/bblabelUI.tscn")
var label = label_scene.instance()

onready var timer = $SegmentTime

var SEGMENT_TEXTS = ["Estamos en un segmento de tunel!","Habra que pasar por el medio!!"]
var FIRE_TEXTS = ["Este planeta de fuego es peligroso, tengamos cuidado con las paredes."]
var ICE_TEXTS = ["Este planeta es de hielo, podemos quedar pegado a las paredes."]
var EARTH_TEXTS = ["Este planeta de tierra es tranquilo"]

# Story Characters
const Char_Alpha = 	Global.Char_Alpha
const Char_Omega = 	Global.Char_Omega
const Char_Kokoro = Global.Char_Kokoro
const Char_Dummy = 	Global.Char_Dummy

var Chars_Speaking = [Char_Kokoro,Char_Dummy]

func start_segment():
	var time = 15 + difficulty * 2
	label.texts = SEGMENT_TEXTS
	label.character_img = Chars_Speaking
	add_child(label)
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
	tunnel.top_texture = lava_texture
	tunnel.bot_texture = lava_texture
	tunnel.can_damage = true
	add_child(tunnel)
