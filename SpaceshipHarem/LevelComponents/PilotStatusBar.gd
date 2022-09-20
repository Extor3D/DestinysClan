extends Node2D

onready var fill_meter = $FillMeter
onready var meter = $Meter
onready var form_icon = $Form

var ship_scene = preload("res://Player/SmallShip.tscn")

var ship = null
var req_energy = 10

func set_pilot(p):
	if ship:
		ship.queue_free()
	var s = ship_scene.instance()
	s.main_color = p.color
	s.specie = p.specie
	s.scale = Vector2(0.5, 0.5)
	s.position = Vector2(25, 10)
	add_child(s)
	ship = s
	set_form_data(p.formation)
	
func set_form_data(id):
	var form = Global.get_form_by_id(id)
	form_icon.texture = load(form.icon)
	req_energy = form.energy_req

func set_meter(e):
	var f = clamp(float(e / req_energy), 0, 1)
	draw_bar(fill_meter, f)

func draw_bar(bar, f):
	var poly = meter.get_polygon()
	poly[1] = poly[0].linear_interpolate(poly[1], f)
	poly[2] = poly[3].linear_interpolate(poly[2], f)
	bar.set_polygon(PoolVector2Array(poly))
