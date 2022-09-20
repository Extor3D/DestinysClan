extends Segment

onready var timer = $SegmentTime1
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var TUTORIAL_TEXTS1 = ["Bienvenidos al [b]Simulador de batalla[/b].\nAqui les enseñare lo basico, aunque seguramente no lo necesiten. Todos aqui somos veteranos de las guerras conicas verdad? No?\nEste es un momento muy incomodo para todos asi que como dicen 'Al mal paso darle prisa'\n[b][color=green]Presiona Z o ENTER para continuar[/color][/b] ",
"[b][color=#ffc0cb]Alpha[/color][/b], he configurado los controles de tu nave segun tus preferencias (Esta nave se controla con [b][color=#00FF00]WASD[/color][/b]).", 
"En tu caso [b][color=yellow]Omega[/color][/b], hemos vuelto a los controles basicos, se que no tendras quejas (Esta nave se controla con las [b][color=#00FF00]flechas[/color][/b]). Se conocen hace mucho y los une un [b][color=red]VINCULO[/color][/b] muy estrecho, asi que creo que no hacen falta las presentaciones despues de todo."	, 
"Se preguntaran que son esas naves del medio...  Es un experimento que he estado planificando, si tiene exito en el simulador, lo podremos trasladar a naves reales!\nEsas 3 naves son [b][color=#FFD700]Naves Conectoras[/color][/b].",  
"Cuando una nave une a la formacion entre las naves de ustedes 2 forma una [b][color=red]Cadena[/color][/b]. Esta cadena liberara todo su potencial. Por ahora he incluido 3 naves con pilotos de choques. No serviran de mucho pero quizas [b][color=red]Alguien Especial[/color][/b] se una a ustedes en su travesia.\nPero basta de chacharas, vamos a movernos!",
"En la pantalla veran muchas barras y graficos. No se asusten!\nArriba a la izquierda hay 2 barras, la de arriba de todo es la [b][color=red]SALUD[/color][/b] de la formacion, la segunda es tu [b][color=#728FCE]ENERGIA[/color][/b]. Como veran, esta se recarga poco a poco.\nUna particularidad de su poder es que [b][color=#00FF00]todas tus naves comparten salud. Si golpean a una golpean a todas[/color][/b].  "	, 
#"La segunda barra, corresponde a la energia disponible, se recarga automaticamente y te servira para [b][color=#00FF00]Activar Formaciones[/color][/b]  "	, 
"Ahora simulare una pared de asteroides. Es imposible de atravesarla para una nave convencional...  [b][color=#00FF00]Los asteroides dañaran cualquiera de tus naves que colisionen[/color][/b].\nAqui es donde entra en juego su [b][color=red]PODER[/color][/b]. ", 
"He incluido una [b][color=#b2ffff]FORMACION[/color][/b] a la cadena de naves. Si en algun momento, ubican las naves de forma de imitar esa formacion, [b][color=red]algo especial sucedera[/color][/b]..."	, 
"En la parte inferior de la pantalla veras las formaciones que tienes disponibles. [b][color=#b2ffff]Las 3 naves de prueba tienen la misma.[/color][/b]\nAl lado de cada formacion, hay una barra que te indicara cuando esta disponible para ser utilizada."	, 
"Ahora, prueba formar una [b][color=#b2ffff]V invertida hacia adelante (>)[/color][/b] y luego apreten el boton ACTIVAR ([b][color=#00FF00]Barra espaciadora[/color][/b])  .",  
]

var ERROR_TEXT = ["Bueno, eso no salio muy bien, probemos otra vez"]

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var obstacle_scene = preload("res://Scenery/Obstacle.tscn")
var rng = RandomNumberGenerator.new()
var spawner

var spawners = []
var	time
var ended = false
var label_off = false
var label = label_scene.instance()

func start_segment():
	rng.randomize()
	label.texts = TUTORIAL_TEXTS1
	add_child(label)
	#print(get_parent().get_parent().get_child(1))
	var playernode = get_parent().get_parent().get_child(1)
	playernode.connect("formation_done",self,"formation")
	label.connect("end_label",self,"finish1")


	
func _on_SegmentTime_timeout():
	# Mas adelante Agregar Label de Repeticion para el Tutorial
	label.container.visible = true
	label.texts = ERROR_TEXT
	if !ended:
		time = 5
		timer.start(time)
		add_asteroid_field(time)

func finish1():
	label_off = true
	if !ended:
		time = 5
		timer.start(time)
		add_asteroid_field(time)
		
		
func formation():
	ended = true
	if label_off:
		remove_child(label)
		end_segment()

func _ready():
	pass
	
	
func add_asteroid_field(duration):
	spawner = spawner_scene.instance()
	spawner.scene = obstacle_scene
	var vars = {"speed": -150,
				"rot_spd": rng.randi_range(2, 3)}
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 500
	spawner.start_time = 0
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(0.2)
	add_child(spawner)


