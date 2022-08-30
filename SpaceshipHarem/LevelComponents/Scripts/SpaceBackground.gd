extends Node2D
class_name SpaceBackground

export (Global.themes) var theme = Global.themes.LAND

onready var background = $Background
onready var dust_scroll = $DustScroll
onready var dust = $DustScroll/Dust
onready var nebulae_scroll = $NebulaeScroll	
onready var nebulae = $NebulaeScroll/Nebulae
onready var planets_scroll = $PlanetsScroll
onready var planets = $PlanetsScroll/Planets

onready var global_scheme = preload("res://Generators/SpaceBackground/BackgroundGenerator/Colorscheme.tres")

var space_color = PoolColorArray([Color(0.00392157, 0.0352941, 0.0588235, 1),
								  Color(0.0313726, 0.0784314, 0.117647, 1), 
								  Color(0.0588235, 0.164706, 0.247059, 1), 
								  Color(0.12549, 0.223529, 0.309804, 1), 
								  Color(0.305882, 0.286275, 0.372549, 1), 
								  Color(0.505882, 0.384314, 0.443137, 1), 
								  Color(0.6, 0.458824, 0.466667, 1), 
								  Color(0.764706, 0.639216, 0.541176, 1), 
								  Color(0.964706, 0.839216, 0.741176, 1)])

var cold_color = PoolColorArray([Color(0.0666667, 0.0941176, 0.215686, 1), 
								 Color(0.12549, 0.156863, 0.305882, 1), 
								 Color(0.172549, 0.290196, 0.470588, 1), 
								 Color(0.219608, 0.458824, 0.631373, 1),
								 Color(0.545098, 0.792157, 0.866667, 1), 
								 Color(0.45098, 0.552941, 0.615686, 1), 
								 Color(0.654902, 0.737255, 0.788235, 1), 
								 Color(0.839216, 0.882353, 0.913725, 1), 
								 Color(1, 1, 1, 1)])
								
var fire_color = PoolColorArray([Color(0.0901961, 0.0901961, 0.0666667, 1), 
								 Color(0.12549, 0.133333, 0.0823529, 1), 
								 Color(0.227451, 0.156863, 0.00784314, 1), 
								 Color(0.588235, 0.235294, 0.235294, 1), 
								 Color(0.792157, 0.352941, 0.180392, 1), 
								 Color(1, 0.470588, 0.192157, 1), 
								 Color(0.952941, 0.6, 0.286275, 1), 
								 Color(0.921569, 0.760784, 0.458824, 1), 
								 Color(0.87451, 0.843137, 0.521569, 1)])

func _ready():
	var  new_size = Vector2(1000,480)
	background.rect_min_size = new_size
	background.rect_size = new_size
	background.set_mirror_size(new_size)
	background.toggle_planets()
	background.toggle_nebulae()
	background.toggle_dust()
	background.generate_new()
	
	dust.rect_min_size = new_size
	dust.rect_size = new_size
	dust.set_mirror_size(new_size)
	dust.toggle_nebulae()
	dust.toggle_stars()
	dust.toggle_planets()
	dust.toggle_transparancy()
	dust.generate_new()
	
	nebulae.rect_min_size = new_size
	nebulae.rect_size = new_size
	nebulae.set_mirror_size(new_size)
	nebulae.toggle_dust()
	nebulae.toggle_stars()
	nebulae.toggle_planets()
	nebulae.toggle_transparancy()
	nebulae.generate_new()
	
	planets.rect_min_size = new_size
	planets.rect_size = new_size
	planets.set_mirror_size(new_size)
	planets.toggle_dust()
	planets.toggle_nebulae()
	planets.toggle_stars()
	planets.toggle_transparancy()
	planets.generate_new()
	
	match theme:
		Global.themes.LAND:
			select_colorscheme(background, space_color)
		Global.themes.FIRE:
			select_colorscheme(background, fire_color)
		Global.themes.ICE:
			select_colorscheme(background, cold_color)
	
	
func select_colorscheme(back, scheme):
	back.set_background_color(scheme[0])
	scheme.remove(0)
	global_scheme.gradient.colors = scheme

func _process(_delta):
	position.x -= 0.005 
	dust_scroll.position.x -= 0.01
	nebulae_scroll.position.x -= 0.03 
	planets_scroll.position.x -= 0.1

