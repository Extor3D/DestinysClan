extends Node2D

onready var bench_list_component = $Screen/Columns/BenchContainer/BenchList
onready var equip_list_component = $Screen/Columns/PartyContainer/PartyList

onready var pilot_name_component = $Screen/Columns/PilotContainer/PilotName
onready var pilot_portrait_component = $Screen/Columns/PilotContainer/CenterContainer/PilotPortrait
onready var dummy_portrait_component = $Screen/Columns/PilotContainer/CenterContainer/DummySprite
onready var pilot_stats_component = $Screen/Columns/PilotContainer/StatsList
onready var pilot_form_component = $Screen/Columns/PilotContainer/FormValue
onready var pilot_species_component = $Screen/Columns/PilotContainer/SpeciesValue

const equip_func = "equip_pilot"
const unequip_func = "unequip_pilot"

func _ready():
	for p in Global.benched_pilots:
		add_button(bench_list_component, p, equip_func)
	for p in Global.equipped_pilots:
		add_button(equip_list_component, p, unequip_func)

func equip_pilot(p, b):
	Global.equipped_pilots.append(p)
	Global.benched_pilots.remove(Global.benched_pilots.find(p))
	b.queue_free()
	add_button(equip_list_component, p, unequip_func)
	
func unequip_pilot(p, b):
	Global.benched_pilots.append(p)
	Global.equipped_pilots.remove(Global.equipped_pilots.find(p))
	b.queue_free()
	add_button(bench_list_component, p, equip_func)
	
func add_button(list, data, function):
	var b = Button.new()
	b.text = data.name
	list.add_child(b)
	b.connect("button_down", self, function, [data, b])
	b.connect("focus_entered", self, "on_focus_button", [data])
	b.connect("mouse_entered", self, "on_focus_button", [data])
	b.grab_focus()

func on_focus_button(data):
	if data.specie == Global.DUMMY_ID:
		dummy_portrait_component.show()
		pilot_portrait_component.hide()
	else:
		dummy_portrait_component.hide()
		pilot_portrait_component.show()
		pilot_portrait_component.set_data(data)
	pilot_name_component.text = data.name
	pilot_form_component.text = tr(Global.get_form_by_id(data.formation).name)
	pilot_species_component.text = data.specie

func _on_FinishButton_pressed():
	Global.goto_scene("res://UI/Screens/LevelSelect.tscn")
