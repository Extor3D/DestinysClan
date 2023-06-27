extends Node2D

onready var bench_list_component = $Screen/Columns/BenchContainer/BenchList
onready var equip_list_component = $Screen/Columns/PartyContainer/PartyList

onready var stat_damage_component = $Screen/Columns/StatsContainer/VBoxContainer/StatsList/StatDamage
onready var stat_maxhp_component = $Screen/Columns/StatsContainer/VBoxContainer/StatsList/StatMaxHP
onready var stat_speed_component = $Screen/Columns/StatsContainer/VBoxContainer/StatsList/StatSpeed
onready var stat_maxenergy_component = $Screen/Columns/StatsContainer/VBoxContainer/StatsList/StatMaxEnergy
onready var stat_recspeed_component = $Screen/Columns/StatsContainer/VBoxContainer/StatsList/StatRecoverySpeed

onready var pilot_name_component = $Screen/Columns/PilotContainer/PilotName
onready var pilot_portrait_component = $Screen/Columns/PilotContainer/CenterContainer/PilotPortrait
onready var dummy_portrait_component = $Screen/Columns/PilotContainer/CenterContainer/DummySprite
onready var pilot_stats_component = $Screen/Columns/PilotContainer/StatsList
onready var pilot_form_component = $Screen/Columns/PilotContainer/FormValue
onready var pilot_species_component = $Screen/Columns/PilotContainer/SpeciesValue

const equip_func = "equip_pilot"
const unequip_func = "unequip_pilot"

var stat_range = 1
var stat_energy = 1
var stat_health = 1
var stat_mind = 1
var stat_agility = 1

func _ready():
	for p in Global.benched_pilots:
		add_button(bench_list_component, p, equip_func)
	for p in Global.equipped_pilots:
		add_button(equip_list_component, p, unequip_func)
	sum_stats()

func equip_pilot(p, b):
	Global.equipped_pilots.append(p)
	Global.benched_pilots.remove(Global.benched_pilots.find(p))
	b.queue_free()
	add_button(equip_list_component, p, unequip_func)
	sum_stats()
	
func unequip_pilot(p, b):
	Global.benched_pilots.append(p)
	Global.equipped_pilots.remove(Global.equipped_pilots.find(p))
	b.queue_free()
	add_button(bench_list_component, p, equip_func)
	sum_stats()
	
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
	show_stats_from_pilot(data)
	
func sum_stats():
	stat_agility = 1
	stat_energy = 1
	stat_mind = 1
	stat_range = 1
	stat_health = 1
	
	for p in Global.equipped_pilots:
		add_stats_from_ship(p)
		
	stat_damage_component.text = Global.get_stat_by_id(Global.STAT_NAMES.Damage).name + ": " + str(stat_range)
	stat_speed_component.text = Global.get_stat_by_id(Global.STAT_NAMES.Speed).name + ": " + str(stat_agility)
	stat_maxenergy_component.text = Global.get_stat_by_id(Global.STAT_NAMES.MaxEnergy).name + ": " + str(stat_energy)
	stat_maxhp_component.text = Global.get_stat_by_id(Global.STAT_NAMES.MaxHP).name + ": " + str(stat_health)
	stat_recspeed_component.text = Global.get_stat_by_id(Global.STAT_NAMES.RecoverySpeed).name + ": " + str(stat_mind)

func add_stats_from_ship(s):
	for i in s.stats:
		add_stat(i[1], i[0])
	
func add_stat(stat, amount):
	match stat:
		Global.STAT_NAMES.Damage:
			stat_range = clamp(stat_range + amount, 1, 10)
		Global.STAT_NAMES.MaxEnergy:
			stat_energy = clamp(stat_energy + amount, 1, 10)
		Global.STAT_NAMES.MaxHP:
			stat_health = clamp(stat_health + amount, 1, 10)
		Global.STAT_NAMES.RecoverySpeed:
			stat_mind = clamp(stat_mind + amount, 1, 10)
		Global.STAT_NAMES.Speed:
			stat_agility = clamp(stat_agility + amount, 1, 10)

func show_stats_from_pilot(data):
	for n in pilot_stats_component.get_children():
		pilot_stats_component.remove_child(n)
		n.queue_free()
		
	for d in data.stats:
		var label = Label.new()
		label.align = Label.ALIGN_CENTER
		label.text = Global.get_stat_by_id(d[1]).name + ": " + str(d[0])
		pilot_stats_component.add_child(label)

func _on_FinishButton_pressed():
	Global.goto_scene("res://UI/Screens/LevelSelect.tscn")
