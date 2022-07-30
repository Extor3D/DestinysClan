extends Node2D

onready var hp_bar = $HPBar
onready var en_bar = $EnergyBar

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

func _ready():
	pass

func _process(delta):
	#If the Player is still alive, we get the energy and health from it
	if get_parent().has_node("Player"):
		var player = get_parent().get_node("Player")
		$Label.text = str(player.energy)
		var perc_hp = float(player.health) / player.max_health
		var perc_en = player.energy / player.max_energy
		draw_bar(hp_left, hp_top, hp_height, hp_slope, perc_hp * hp_length, hp_bar, get_col_array(Color.red, Color.yellow, perc_hp))
		draw_bar(en_left, en_top, en_height, en_slope, perc_en * en_length, en_bar, get_col_array(Color.red, Color.green, perc_en))
	else:
		draw_bar(hp_left, hp_top, hp_height, hp_slope, 0, hp_bar, get_col_array(Color.red, Color.yellow, 0))

func draw_bar(left, top, height, slope, length, bar, col):
	var poly : Array
	poly.append(Vector2(left, top + height))
	poly.append(Vector2(left + slope, top))
	poly.append(Vector2(left + slope + length, top))
	poly.append(Vector2(left + length, top + height))
	bar.set_polygon(PoolVector2Array(poly))
	bar.set_vertex_colors(col)
	
func get_col_array(start_col, end_col, perc):
	var array : PoolColorArray
	var col = start_col.linear_interpolate(end_col, perc)
	array.append(start_col)
	array.append(start_col)
	array.append(col)
	array.append(col)
	return array
