extends Area2D

export(String) var specie = "Dummy"
export(Color) var main_color = Color.red

onready var sprite = $SmallShipSprite
onready var mat: ShaderMaterial = $SmallShipSprite.material

func _ready():
	var specie_data = Global.get_specie_by_name(specie)
	if specie_data == null:
		sprite.texture = load("res://Player/Sprites/Races/dummy_ship.png")
	else:
		sprite.texture = load("res://Player/Sprites/Races/" + specie_data[4])
		
	mat.set_shader_param("u_light_replacement_color", main_color)
	mat.set_shader_param("u_dark_replacement_color", main_color.darkened(0.3))
	

func _process(_delta):
	global_rotation = 0
