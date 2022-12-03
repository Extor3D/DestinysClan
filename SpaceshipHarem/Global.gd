extends Node

enum themes {LAND = 1, FIRE = 2, ICE = 3}
enum STAT_NAMES {MaxHP, Speed, Damage, MaxEnergy, RecoverySpeed}

var STATS = [{name = "Max HP", id = STAT_NAMES.MaxHP},
			{name = "Speed", id = STAT_NAMES.Speed},
			{name = "Damage", id = STAT_NAMES.Damage},
			{name = "Max Energy", id = STAT_NAMES.MaxEnergy},
			{name = "Recovery Speed", id = STAT_NAMES.RecoverySpeed}]


var SPECIES =   [["Gatashi",[7,13,15],STAT_NAMES.MaxHP,["Y","G"],"cat_ship.png"],
				 ["Diablo",[5,6,4],STAT_NAMES.Speed,["O","X"],"diablo_ship.png"],
				 ["Humano",[17,18,11],STAT_NAMES.Damage,["F1","F2"],"human_ship.png"],
				 ["Marciano",[9,8,10,16],STAT_NAMES.MaxEnergy,["M","W"],"martian_ship.png"],
				 ["Androide",[2,3,12,14],STAT_NAMES.RecoverySpeed,["B1","B2"],"android_ship.png"]] 
				
				
var PILOT_FORMATIONS ={
	"O":"Detener el tiempo",
	"U":"Restauracion",
	"C":"Supervelocidad",
	"A":"Disparos Veloces",
	"L": "Carga Rapida"
}
var current_scene = null

const FORM_LOW_DEF = ">"
const FORM_LOW_ARROW = "-"
const FORM_DEF = "D"
const FORM_LIFE = "U"
const FORM_VEL = "C"
const FORM_ARROW = "A"
const FORM_ENER = "L"
const FORM_WORLD = "O"
const FORMATIONS = [{id = FORM_LOW_DEF, scene_path = "res://Player/Formations/LowDForm.tscn", icon = "res://Player/Formations/Sprites/low_d_form_icon.png", energy_req = 15},
					{id = FORM_DEF, scene_path = "res://Player/Formations/DForm.tscn", icon = "res://Player/Formations/Sprites/d_form_icon.png", energy_req = 10},
					{id = FORM_ARROW, scene_path = "res://Player/Formations/ArrowForm.tscn", icon = "res://Player/Formations/Sprites/arrow_form_icon.png", energy_req = 15},
					{id = FORM_LIFE, scene_path = "res://Player/Formations/UForm.tscn", icon = "res://Player/Formations/Sprites/u_form_icon.png", energy_req = 20},
					{id = FORM_VEL, scene_path = "res://Player/Formations/CForm.tscn", icon = "res://Player/Formations/Sprites/c_form_icon.png", energy_req = 10},
					{id = FORM_ENER, scene_path = "res://Player/Formations/LForm.tscn", icon = "res://Player/Formations/Sprites/L_form_icon.png", energy_req = 1},
					{id = FORM_WORLD, scene_path = "res://Player/Formations/OForm.tscn", icon = "res://Player/Formations/Sprites/o_form_icon.png", energy_req = 20}
					]

var WARNING_COLOR = Color.orange

#Game globals
var rng = RandomNumberGenerator.new()
var level = 1
var current_difficulty = 1
var current_theme = themes.LAND

#Player globals
var current_pilots = []

# Story Characters
const Char_Alpha = 	"res://Player/Sprites/candidates/pilot/candidate116.png"
const Char_Omega = 	"res://Player/Sprites/candidates/pilot/candidate011.png"
const Char_Kokoro = "res://Player/Sprites/candidates/pilot/candidate103.png"
const Char_Dummy = 	"res://Player/Sprites/candidates/pilot/dummypilot.png"

func get_stat_by_id(id):
	for i in STATS.size():
		if STATS[i].id == id:
			return STATS[i]
	return null

func get_form_by_id(id):
	for i in FORMATIONS.size():
		if FORMATIONS[i].id == id:
			return FORMATIONS[i]
	return null

func get_specie_by_name(name):
	for i in SPECIES.size():
		if SPECIES[i][0] == name:
			return SPECIES[i]
	return null

func get_random_theme_key():
	return themes.keys()[rng.randi() % themes.size()]

func _ready():
	rng.randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	new_game(FORM_LOW_DEF)
	
func new_game(f_id):
	current_pilots = []
	current_pilots.append(get_dummy_data("Dummy", Color.yellow, f_id))
	current_pilots.append(get_dummy_data("Dummy", Color.yellow, f_id))
	current_pilots.append(get_dummy_data("Dummy", Color.yellow, f_id))
	level = 1
	current_difficulty = 1
	current_theme = themes.LAND

func get_dummy_data(sp, co, f_id):
	var data = {
		name = "dum",
		formation = f_id,
		stats = [[1, Global.STAT_NAMES.values()[randi() % Global.STAT_NAMES.size()]]],
		color = co, 
		specie = sp
	}
	return data
	
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
