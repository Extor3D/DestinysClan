extends Node2D

onready var hp_bar = $HPBar
onready var en_bar = $EnergyBar
onready var b_bar = $BossBar
onready var level = get_parent()

var pilot_bar_scene = preload("res://LevelComponents/PilotStatusBar.tscn")

var boss_active = false
var boss = null
var boss_path = null

var hp_length = 200
var hp_top = 10
var hp_left = 10
var hp_height = 10
var hp_slope = 10

var en_length = 200
var en_top = 25
var en_left = 10
var en_height = 5
var en_slope = 5

var b_length = -200
var b_top = 10
var b_left = 632
var b_height = 10
var b_slope = -10

var p_length = 60
var p_top = 320
var p_left = 10
var p_slope = 20 
var p_bars = []

var segments_bars = []
var segment_dist : float = 2
var segment_top = 10
var segment_height = 15
var segment_slope = 15
var segment_left = 217
var segment_length = 200

func _ready():
	level.connect("new_segment", self, "paint_segment")
	get_parent().connect("boss_spawned", self, "show_boss_hp")
	for i in Global.current_pilots.size():
		var pilot_node = pilot_bar_scene.instance()
		pilot_node.position = Vector2(p_left + i * (p_length + p_slope), p_top)
		add_child(pilot_node)
		pilot_node.set_pilot(Global.current_pilots[i])
		p_bars.append(pilot_node)

func _process(_delta):
	#If the Player is still alive, we get the energy and health from it
	if get_parent().has_node("Player"):
		var player = get_parent().get_node("Player")
		var perc_hp = float(player.health) / player.max_health
		var perc_en = player.energy / player.max_energy
		draw_bar(hp_left, hp_top, hp_height, hp_slope, perc_hp * hp_length, hp_bar, get_col_array(Color.red, Color.yellow, perc_hp))
		draw_bar(en_left, en_top, en_height, en_slope, perc_en * en_length, en_bar, get_col_array(Color.red, Color.green, perc_en))
		for p in p_bars:
			p.set_meter(player.energy)
	else:
		draw_bar(hp_left, hp_top, hp_height, hp_slope, 0, hp_bar, get_col_array(Color.red, Color.yellow, 0))
	
	if segments_bars.empty():
		for i in level.segments.size():
			var segment = Polygon2D.new()
			draw_segment_bar(segment, i, level.segments.size())
			segments_bars.append(segment)
			add_child(segment)
			paint_segment(0)
	
	if boss_active and has_node(boss_path):
		var perc_hp = float(boss.health) / boss.max_health
		draw_bar(b_left, b_top, b_height, b_slope, perc_hp * b_length, b_bar, get_col_array(Color.red, Color.yellow, perc_hp))
			
func show_boss_hp(b):
	boss = b
	boss_path = b.get_path()
	boss_active = true

func paint_segment(n):
	for i in segments_bars.size():
		var s = segments_bars[i]
		if n >= segments_bars.size():
			s.set_vertex_colors(get_col_array(Color.red, Color.red, 1))
		elif n == i:
			s.set_vertex_colors(get_col_array(Color.yellow, Color.yellow, 1))
		else:
			s.set_vertex_colors(get_col_array(Color.green, Color.green, 1))
			
func draw_bar(left, top, height, slope, length, bar, col):
	var poly : Array = []
	poly.append(Vector2(left, top + height))
	poly.append(Vector2(left + slope, top))
	poly.append(Vector2(left + slope + length, top))
	poly.append(Vector2(left + length, top + height))
	bar.set_polygon(PoolVector2Array(poly))
	bar.set_vertex_colors(col)
	
func draw_segment_bar(s, i, n):
	var poly : Array = []
	var top_left = Vector2(segment_left + segment_slope + i * float((segment_length - segment_slope) / n) + segment_dist, segment_top)
	var top_right = Vector2(segment_left + segment_slope + (i + 1) * float((segment_length - segment_slope) / n) - segment_dist, segment_top)
	var bot_left = Vector2(segment_left + i * (float(segment_length + segment_slope) / n) + segment_dist, segment_top + segment_height)
	var bot_right = Vector2(segment_left + (i + 1) * (float(segment_length + segment_slope) / n) - segment_dist, segment_top + segment_height)
	
	poly.append(bot_left)
	poly.append(top_left)
	poly.append(top_right)
	poly.append(bot_right)
	s.set_polygon(poly)
	s.set_vertex_colors(get_col_array(Color.green, Color.green, 1))
	
func get_col_array(start_col, end_col, perc):
	var array : PoolColorArray = []
	var col = start_col.linear_interpolate(end_col, perc)
	array.append(start_col)
	array.append(start_col)
	array.append(col)
	array.append(col)
	return array
