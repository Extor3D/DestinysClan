extends Control

var ship_scene = preload("res://Player/SmallShip.tscn")

onready var screen:= $Viewport
onready var portrait:= $Viewport/PilotPortrait
onready var label:= $MarginContainer/HBoxContainer/Label
onready var pilot_data:= $Pilot_data

var final_data

func _randomize():
	
	var data = portrait.create_random_data()
	
	label.text = data.name +" , " + str(data.age) + ".\n  " + data.occupation+ ".\n A unos " + str(data.distance) + " millones de kilómetros de ti."
	#str(data["Hair/Front"]) # 
	
	pilot_data.add_text('\n' + "[b][color="+ str(data.skin_light_color)+"]" + data.specie + '[/color][/b]\n' )
	pilot_data.add_text('\n[wave]' + data.flavor + '[/wave]\n\n' + "Formacion: [rainbow freq=0.5 sat=10 val=20]" + data.formation + '[/rainbow]\n\n')

	var main_stat_name = Global.get_stat_by_id(data.stats[0][1]).name

	pilot_data.add_text("[b]HÁBITOS | INTERESES[/b]" + '\n[rainbow freq=0.1]' + main_stat_name + " + " + str(data.stats[0][0]) + '[/rainbow]\n')
	if (data.stats[1][0] > 0):
		pilot_data.add_text('[rainbow freq=0.1]' + data.stats[1][1] + " + " + str(data.stats[1][0]) + "[/rainbow]")

	var s = ship_scene.instance()
	s.specie = data.specie
	s.main_color = data.color
	pilot_data.add_child(s)
	s.position = Vector2(220,270)
	
	final_data = data
	portrait.set_data(data)

func _resized():
	var scale:= int(max(5.0*min((OS.window_size.x-60)/1024.0, 1.5*(OS.window_size.y-130)/600.0), 1))
	$Portrait.rect_size = 96*scale*Vector2(1.0,1.0)

func _ready():
	randomize()
	_resized()
	get_tree().connect("screen_resized", self, "_resized")
	
	_randomize()
