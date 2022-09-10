extends Segment

onready var timer = $SegmentTime3
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var TUTORIAL_TEXTS3 = ["Grandioso!!! Otro exito!\n Estan casi listos para salir al espacio.",
"En su aventura visitaran varios planetas y lamentablemente, estan fuertemente armados.\nEs probable que se topen tarde o temprano con una [b][color=green]nave imperial[/color][/b].",
"Las naves imperiales [b][color=#00FF00]estan fuertemente armadas y son mucho mas resistentes[/color][/b] que las naves normales.\nGeneralmente sera la ultima linea de defensa que tiene un planeta. ",
"Simulare una de estas naves para que aprendan a lidiar con ellas.\n[b][color=#00FF00]Recuerda todo los disparos que te dañan son de color rojo[/color][/b]\nMucha suerte!!"]


var texts_number = 0
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/Bosses/RandomBoss.tscn")

var spawners = []
var time = 0

var rng = RandomNumberGenerator.new()
var ended3 = false
var label = label_scene.instance()


func start_segment():
	time = 1
	label.texts = TUTORIAL_TEXTS3
	add_child(label)
	label.connect("end_label",self,"finish")

	
func _on_SegmentTime_timeout():
	ended3 = true
	end_segment()
	print("Termine segmento 3")

func finish():
	if !ended3:
		print("Termine3")
		#spawners.append(add_enemy_group(1,3,primary_enemy_scene))
		timer.start(time)
		remove_child(label)

func _ready():
	rng.randomize()

	
	
func add_enemy_group(duration,start,enemy):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = {"move_speed": -70 + -difficulty*3,
				"rot_spd": rng.randi_range(2, 3),
				"cadence":100}
	spawner.scene_variables = vars
	spawner.y_center = 20 + (60 * rand_range(0,4))
	spawner.height = 20 + (10* difficulty) 
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(1.35 - 0.2 * difficulty)
	add_child(spawner)
	return spawner


