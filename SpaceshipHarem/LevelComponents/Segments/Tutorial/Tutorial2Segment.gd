extends Segment

onready var timer = $SegmentTime2
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var EX_TUTORIAL_TEXTS2 = ["Ups... creo que se me paso la mano... es decir... Excelente!!! Sabia que lo lograrian! \nVan entendiendo como funciona su [b][color=red]PODER[/color][/b].\nHay una ventaja adicional... a diferencia de los asteroides, las naves y disparos enemigos, [b][color=#00FF00]no dañan a tus naves conectoras, esa es otra ventaja de la cadena.[/color][/b]",
"Habras notado que he configurado tus armas en automatico, por lo que [b][color=#00FF00]tus naves disparan todo el tiempo[/color][/b]. ", 
"Probemos nuevamente. Simulare algunos enemigos, recuerda que [b][color=#00FF00]los disparos y las naves solo dañan tu primera y ultima nave[/color][/b].\nLo importante aqui es esquivar, no necesitas encargarte de todos los enemigos." ]

var TUTORIAL_TEXTS2 = [" Excelente!!! Sabia que lo lograrian! \n Puede parecerles algo incomodo tener sus naves unidas, pero tiene su utilidad. Ya lo veran!",
"Lo siguiente... He configurado sus armas en automatico, por lo que [b][color=#00FF00]tus naves disparan todo el tiempo[/color][/b].  Eso les ahorrara el pensar en atacar, concentrense en moverse!", 
"Probemos nuevamente. Simulare algunos enemigos mas, recuerda que [b][color=#00FF00]los disparos y las naves solo dañan tu primera y ultima nave[/color][/b].\nLo importante aqui es esquivar, no necesitas encargarte de todos los enemigos." ]

#var TUTORIAL_TEXTS2 = [tr("TUTORIAL_S2_L1"),
#tr("TUTORIAL_S2_L2"), 
#tr("TUTORIAL_S2_L3"), 
#tr("TUTORIAL_S2_L4"), ]

var texts_number = 0
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/SpecieEnemy.tscn")
var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")
var tertiary_enemy_scene = preload("res://Enemies/Enemy2.tscn")

var spawners = []
var time = 0
var ended2 = false
var label = label_scene.instance()
var rng = RandomNumberGenerator.new()

func start_segment():
	time = 21
	label.texts = TUTORIAL_TEXTS2
	add_child(label)
	label.connect("end_label",self,"finish")

func _on_SegmentTime_timeout():
	ended2 = true
	end_segment()

func finish():
	if !ended2:
		spawners.append(add_enemy_group(time/3,3,primary_enemy_scene))
		spawners.append(add_enemy_group(time/3,time/3,secondary_enemy_scene))
		spawners.append(add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene))
		timer.start(time)
		remove_child(label)

func _ready():
	
	rng.randomize()

	
	
func add_enemy_group(duration,start,enemy):
	var spawner = spawner_scene.instance()
	spawner.scene = enemy
	var vars = {"move_speed": -70,
				"rot_spd": rng.randi_range(2, 3),
				"cadence":5}
	spawner.scene_variables = vars
	spawner.y_center = 20 + (60 * rand_range(0,4))
	spawner.height = 30 
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(1)
	add_child(spawner)
	return spawner


