extends Node2D

enum themes {NONE = 1, FIRE = 2, ICE = 3}

export (themes) var theme = themes.NONE
export (int, 1, 1000) var size = 300

var colors = []
var planet

onready var planets = {
	"Terran Wet": preload("res://Generators/World/Planets/Rivers/Rivers.tscn"),
	"Terran Dry": preload("res://Generators/World/Planets/DryTerran/DryTerran.tscn"),	
	"Islands": preload("res://Generators/World/Planets/LandMasses/LandMasses.tscn"),
	"No atmosphere": preload("res://Generators/World/Planets/NoAtmosphere/NoAtmosphere.tscn"),
	"Gas giant 1": preload("res://Generators/World/Planets/GasPlanet/GasPlanet.tscn"),
	"Gas giant 2": preload("res://Generators/World/Planets/GasPlanetLayers/GasPlanetLayers.tscn"),
	"Ice World": preload("res://Generators/World/Planets/IceWorld/IceWorld.tscn"),
	"Lava World": preload("res://Generators/World/Planets/LavaWorld/LavaWorld.tscn"),
	"Asteroid": preload("res://Generators/World/Planets/Asteroids/Asteroid.tscn"),
	"Black Hole": preload("res://Generators/World/Planets/BlackHole/BlackHole.tscn"),
	"Galaxy": preload("res://Generators/World/Planets/Galaxy/Galaxy.tscn"),
	"Star": preload("res://Generators/World/Planets/Star/Star.tscn"),
}

func _ready():
	randomize()
	match theme:
		themes.NONE:
			_create_new_planet(planets["Terran Wet"])
		themes.FIRE:
			_create_new_planet(planets["Lava World"])
		themes.ICE:
			_create_new_planet(planets["Ice World"])

func _create_new_planet(type):
	var sd = randi()
	seed(sd)
	planet = type.instance()
	planet.set_pixels(size)
	planet.set_dither(false)
	planet.set_seed(sd)
	add_child(planet)
	

