extends Segment

onready var timer = $SegmentTime1
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var TUTORIAL_TEXTS = [tr("TUTORIAL_S1_L1"),
tr("TUTORIAL_S1_L2"), 
tr("TUTORIAL_S1_L3"), 
tr("TUTORIAL_S1_L4"), 
tr("TUTORIAL_S1_L5"), 
tr("TUTORIAL_S1_L6"), 
tr("TUTORIAL_S1_L7")]
var EXTRA_TEXTS = [
	
"Esta cadena liberara todo su potencial. Por ahora he incluido 3 naves con pilotos de choques. No serviran de mucho pero quizas [b][color=red]Alguien Especial[/color][/b] se una a ustedes en su travesia.\nPero basta de chacharas, vamos a movernos!",

"En la pantalla veran muchas barras y graficos. No se asusten!\nArriba a la izquierda hay 2 barras, la de arriba de todo es la [b][color=red]SALUD[/color][/b] de la formacion, la segunda es tu [b][color=#728FCE]ENERGIA[/color][/b]. Como veran, esta se recarga poco a poco.\nUna particularidad de su poder es que [b][color=#00FF00]todas tus naves comparten salud. Si golpean a una golpean a todas[/color][/b].  "	, 
#"La segunda barra, corresponde a la energia disponible, se recarga automaticamente y te servira para [b][color=#00FF00]Activar Formaciones[/color][/b]  "	, 
"Ahora simulare una pared de asteroides. Es imposible de atravesarla para una nave convencional...  [b][color=#00FF00]Los asteroides dañaran cualquiera de tus naves que colisionen[/color][/b].\nAqui es donde entra en juego su [b][color=red]PODER[/color][/b]. ", 
"He incluido una [b][color=#b2ffff]FORMACION[/color][/b] a la cadena de naves. Si en algun momento, ubican las naves de forma de imitar esa formacion, [b][color=red]algo especial sucedera[/color][/b]..."	, 
"En la parte inferior de la pantalla veras las formaciones que tienes disponibles. [b][color=#b2ffff]Las 3 naves de prueba tienen la misma.[/color][/b]\nAl lado de cada formacion, hay una barra que te indicara cuando esta disponible para ser utilizada."	, 
"Ahora, prueba formar una [b][color=#b2ffff]V invertida hacia adelante (>)[/color][/b] y luego apreten el boton ACTIVAR ([b][color=#00FF00]Barra espaciadora[/color][/b])  .",
tr("TUTORIAL_S1_FAIL")  
]

onready var playernode = get_parent().get_parent().get_child(1)


var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var spawner
var texts_number = 0

var primary_enemy_scene = preload("res://Enemies/SpecieEnemy.tscn")
var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")

var spawners = []
var time = 0
var ended2 = false
var label = label_scene.instance()
var rng = RandomNumberGenerator.new()
var cadence = 0.5

func start_segment():
	#playernode.set_cadence(1000)
	cadence = playernode.cadence

	print(playernode.cadence)
	time = 11
	label.texts = TUTORIAL_TEXTS
	add_child(label)
	label.connect("end_label",self,"finish")
	

func _on_SegmentTime_timeout():

	ended2 = true
	end_segment()

func finish():
	playernode.set_cadence(cadence)
	if !ended2:
		spawners.append(add_enemy_group(time/3,3,primary_enemy_scene))
		spawners.append(add_enemy_group(time/3,time/3,secondary_enemy_scene))
		spawners.append(add_enemy_group(time/3,time * 2/3,secondary_enemy_scene))
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
	spawner.height = 200 
	spawner.start_time = start
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(1)
	add_child(spawner)
	return spawner
