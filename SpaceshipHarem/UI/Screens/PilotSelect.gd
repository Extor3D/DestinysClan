extends Node2D

var profile_scene = preload("res://Generators/Pilot/scenes/profile.tscn")

onready var profiles = $Profiles
onready var music =$BackgroundMusic
onready var acc_button =$Accept
var profs = []
var curr_prof = 0
var max_profs = 3

func _ready():
	for i in max_profs:
		var prof = profile_scene.instance()
		profs.append(prof)
		profiles.add_child(prof)
		prof.visible = false
	profs[curr_prof].visible = true
	music.play()
	acc_button.grab_focus()
	
func show_prof(id):
	for i in max_profs:
		profs[i].visible = i == id

func _on_Prev_pressed():
	curr_prof = clamp(curr_prof - 1, 0, max_profs - 1)
	show_prof(curr_prof)


func _on_Next_pressed():
	curr_prof = clamp(curr_prof + 1, 0, max_profs - 1)
	show_prof(curr_prof)


func _on_Accept_pressed():
	music.stop()
	Global.benched_pilots.append(profs[curr_prof].final_data)
	Global.goto_scene("res://UI/Screens/EquipPilotsScene.tscn")
