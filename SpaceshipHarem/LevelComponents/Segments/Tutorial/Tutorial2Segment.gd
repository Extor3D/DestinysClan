extends Segment

onready var timer = $SegmentTime2
onready var playernode = get_parent().get_parent().get_child(1)

var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var EX_TUTORIAL_TEXTS2 = ["Ups... creo que se me paso la mano... es decir... Excelente!!! Sabia que lo lograrian! \nVan entendiendo como funciona su [b][color=red]PODER[/color][/b].\nHay una ventaja adicional... a diferencia de los asteroides, las naves y disparos enemigos, [b][color=#00FF00]no dañan a tus naves conectoras, esa es otra ventaja de la cadena.[/color][/b]",
"Habras notado que he configurado tus armas en automatico, por lo que [b][color=#00FF00]tus naves disparan todo el tiempo[/color][/b]. ", 
"Probemos nuevamente. Simulare algunos enemigos, recuerda que [b][color=#00FF00]los disparos y las naves solo dañan tu primera y ultima nave[/color][/b].\nLo importante aqui es esquivar, no necesitas encargarte de todos los enemigos." ]

var TUTORIAL_TEXTS2 = [" Excelente!!! Sabia que lo lograrian! \n Puede parecerles algo incomodo tener sus naves unidas, pero tiene su utilidad. Ya lo veran!",
"Ahora quiero enseñarles algo mas... [b][color=red]El poder que une las tres naves del medio [/color][/b] no solo sirve para hacerlas inmunes al daño tambien les permite usar [b][color=#00FF00]Habilidades Especiales[/color][/b].",
"Estas habilidades son llamadas [b][color=#00FF00]Formaciones[/color][/b], para esta simulacion, les he agregado la [b][color=blue]Formacion >[/color][/b].",
"para activarla, deberas mover tu formacion de nave imitando el signo > y luego apretar [b][color=#00FF00]ESPACIO[/color][/b].",
"En la parte inferior de la pantalla veras unos indicadores que te mostraran las formaciones disponibles y la energia necesaria para activarla. Ademas, los indicadores [b][color=green]brillaran cuando estes en la posicion correcta para activarla[/color][/b].",
"Las 3 naves de prueba tienen la misma [b][color=#00FF00]Formacion >[/color][/b], mas adelante podras conseguir mas.",
"Vamos, intentenlo, tomense su tiempo para perfeccionar esta habilidad."]
#"Lo siguiente... He configurado sus armas en automatico, por lo que [b][color=#00FF00]tus naves disparan todo el tiempo[/color][/b].  Eso les ahorrara el pensar en atacar, concentrense en moverse!", 

#"Probemos nuevamente. Simulare algunos enemigos mas, recuerda que [b][color=#00FF00]los disparos y las naves solo dañan tu primera y ultima nave[/color][/b].\nLo importante aqui es esquivar, no necesitas encargarte de todos los enemigos." ]

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
	playernode.connect("formation_done",self,"formation")
	label.texts = TUTORIAL_TEXTS2
	add_child(label)
	label.connect("end_label",self,"finish")
	
func formation():
	remove_child(label)
	end_segment()

func _on_SegmentTime_timeout():
	end_segment()

func finish():
	pass

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


