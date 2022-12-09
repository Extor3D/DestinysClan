extends Node2D

onready var bench_list_component = $Screen/Columns/BenchContainer/BenchList
onready var equip_list_component = $Screen/Columns/PartyContainer/PartyList

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


func _on_FinishButton_pressed():
	Global.goto_scene("res://UI/Screens/LevelSelect.tscn")
