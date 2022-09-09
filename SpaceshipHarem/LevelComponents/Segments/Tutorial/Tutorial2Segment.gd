extends Segment

onready var timer = $SegmentTime
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var TUTORIAL_TEXTS = ["Excelente!!! Sabia que lo lograrian! \nVan entendiendo como funciona su [b][color=red]PODER[/color][/b].\nHay una ventaja adicional... a diferencia de los asteroides, las naves y disparos enemigos, [b][color=#00FF00]no dañan a tus naves conectoras, esa es otra ventaja de la cadena.[/color][/b]",
"Habras notado que he configurado tus armas en automatico,por lo que  [b][color=#00FF00]tus naves disparan todo el tiempo[/color][/b] . ", 
"Probemos nuevamente, simulare algunos enemigos ,recuerda que [b][color=#00FF00]los disparos y las naves solo dañan tu primera y ultima nave[/color][/b].\nLo importante aqui es esquivar, no necesitas encargarte de todos los enemigos." ]

var texts_number = 0
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/BeeEnemy.tscn")
var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")
var tertiary_enemy_scene = preload("res://Enemies/Enemy2.tscn")

var spawners = []
var time = 0

var rng = RandomNumberGenerator.new()

func start_segment():
	time = 15 + difficulty * 2

	
func _on_SegmentTime_timeout():
	end_segment()
	print("Termine segmento")

func finish():
	print("Termine")
	spawners.append(add_enemy_group(time/3,3,primary_enemy_scene))
	spawners.append(add_enemy_group(time/3,time/3,secondary_enemy_scene))
	spawners.append(add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene))
	timer.start(time)

func _ready():
	rng.randomize()
	var label = label_scene.instance()
	label.texts = TUTORIAL_TEXTS
	add_child(label)
	label.connect("end_label",self,"finish")
	
	
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


