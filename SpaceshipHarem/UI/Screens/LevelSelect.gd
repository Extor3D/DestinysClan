extends Node2D

var planet_scene = preload("res://Generators/World/PlanetGenerator.tscn")

const NAME_PART_1 = ["Mercury","Venus","Vesta","Mars","Jupiter","Saturn","Uranus","Neptune","Giant Pluto","Janus","Minerva","Carmentis","Ceres","Falacer","Flora","Furrina","Palatua","Pomona","Portunus","Vulcan","Volturnus","Fortuna","Aurora","Cupid"]
const NAME_PART_2 = ["Prime", "Tulip", "Centauri","Draconis", "Dracarys", "Melonis", "Tulip" , "Requiem", "Tango", "Bravo"]

const TIPS = [
"Recuerda: Tener mas naves en una formacion significa disparar mas, pero tambien que la formacion sera mas dificil de controlar."
,
"Recuerda: Algunas formaciones seran mas sencillas o mas dificiles, segun cuantos pilotos tengas en tu formacion."
]
onready var planet1 = $VBoxContainer/HBoxContainer/Planet1Container/CenterContainer
onready var planet1_name = $VBoxContainer/HBoxContainer/Planet1Container/PlanetName
onready var planet1_type = $VBoxContainer/HBoxContainer/Planet1Container/HBoxContainer/TypeName
onready var planet1_diff = $VBoxContainer/HBoxContainer/Planet1Container/HBoxContainer2/DiffVal
onready var planet1_button = $VBoxContainer/HBoxContainer/Planet1Container/Planet1Button
onready var planet2 = $VBoxContainer/HBoxContainer/Planet2Container/CenterContainer
onready var planet2_name= $VBoxContainer/HBoxContainer/Planet2Container/PlanetName
onready var planet2_type = $VBoxContainer/HBoxContainer/Planet2Container/HBoxContainer/TypeName
onready var planet2_diff = $VBoxContainer/HBoxContainer/Planet2Container/HBoxContainer2/DiffVal
onready var music = $BackgroundMusic

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	var p1_theme_key = Global.get_random_theme_key()
	var p1 = planet_scene.instance()
	var planet_name_1 = NAME_PART_1[rng.randi() %NAME_PART_1.size()] +" "+ NAME_PART_2[rng.randi() %NAME_PART_2.size()]
	var planet_name_2 = NAME_PART_1[rng.randi() %NAME_PART_1.size()] +" "+ NAME_PART_2[rng.randi() %NAME_PART_2.size()]
	
	p1.theme = Global.themes.get(p1_theme_key)
	p1.size = 100
	planet1.add_child(p1)
	planet1_name.text = planet_name_1
	planet1_type.text = p1_theme_key
	planet1_diff.text = str(Global.current_difficulty + 1)
	music.play()
	
	var p2_theme_key = Global.get_random_theme_key()
	var p2 = planet_scene.instance()
	p2.theme = Global.themes.get(p2_theme_key)
	p2.size = 100
	planet2.add_child(p2)
	planet2_name.text = planet_name_2
	planet2_type.text = p2_theme_key
	planet2_diff.text = str(Global.current_difficulty + 2)
	
	Global.level += 1
	
	planet1_button.grab_focus()

func _on_Planet1Button_pressed():
	Global.current_difficulty = int(planet1_diff.text)
	Global.current_theme = Global.themes.get(planet1_type.text)
	Global.goto_scene("res://LevelComponents/LevelGenerator.tscn")


func _on_Planet2Button_pressed():
	Global.current_difficulty = int(planet2_diff.text)
	Global.current_theme = Global.themes.get(planet2_type.text)
	Global.goto_scene("res://LevelComponents/LevelGenerator.tscn")
