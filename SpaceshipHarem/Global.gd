extends Node

enum themes {LAND = 1, FIRE = 2, ICE = 3}
enum STAT_NAMES {MaxHP, Speed, Damage, MaxEnergy, RecoverySpeed}

var SPECIES =   [["Gatashi",[7,13,15],STAT_NAMES.keys()[STAT_NAMES.MaxHP],["Y","G"],"cat_ship.png"],
				 ["Diablo",[5,6,4],STAT_NAMES.keys()[STAT_NAMES.Speed],["O","X"],"diablo_ship.png"],
				 ["Humano",[17,18,11],STAT_NAMES.keys()[STAT_NAMES.Damage],["F1","F2"],"human_ship.png"],
				 ["Marciano",[9,8,10,16],STAT_NAMES.keys()[STAT_NAMES.MaxEnergy],["M","W"],"martian_ship.png"],
				 ["Androide",[2,3,12,14],STAT_NAMES.keys()[STAT_NAMES.RecoverySpeed],["B1","B2"],"android_ship.png"]] 
var current_scene = null

#Game globals
var rng = RandomNumberGenerator.new()
var level = 1
var current_difficulty = 1
var current_theme = themes.LAND

#Player globals
var current_pilots = []


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
	current_pilots.append(get_dummy_data("Dummy", Color.yellow))
	current_pilots.append(get_dummy_data("Gatashi", Color.green))
	current_pilots.append(get_dummy_data("Humano", Color.crimson))
	current_pilots.append(get_dummy_data("Androide", Color.yellow))
	current_pilots.append(get_dummy_data("Diablo", Color.orange))
	current_pilots.append(get_dummy_data("Marciano", Color.blue))

func get_dummy_data(sp, co):
	var data = {
		name = "dum",
		formation = "P",
		stats = [[2, STAT_NAMES.MaxHP], [1, STAT_NAMES.RecoverySpeed]],
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
