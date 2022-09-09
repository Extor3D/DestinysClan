extends Segment

onready var timer = $SegmentTime
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var TUTORIAL_TEXTS1 = ["Bienvenidos al [b]Simulador de batalla[/b].\nAqui les enseñare lo basico, aunque seguramente no lo necesiten. Todos aqui somos veteranos de las guerras conicas verdad? no?\nEste es un momento muy incomodo para todos asi que como dicen 'Al mal paso darle prisa' ",
"[b][color=#ffc0cb]Alpha[/color][/b], he configurado los controles de tu nave segun tus  preferencias (Esta nave se controla con [b][color=#00FF00]WASD[/color][/b]).", 
"En tu caso [b][color=yellow]Omega[/color][/b] , hemos vuelto a los controles basicos, se que no tendras quejas (Esta nave se controla con las [b][color=#00FF00]flechas[/color][/b]) . Se conocen hace mucho y los une un [b][color=red]VINCULO[/color][/b] muy estrecho, asi que creo que no hacen falta las presentaciones despues de todo."	, 
"Se preguntaran que son esas naves del medio...  Es un experimento que he estado planificando, si tiene exito en el simulador, lo podremos trasladar a naves reales!\nEsas 3 naves son [b][color=#FFD700]Naves Conectoras[/color][/b] .",  
"Cuando una nave une a la formacion entre las naves de ustedes 2 forma una [b][color=red]Cadena[/color][/b] . Esta cadena liberara todo su potencial. Por ahora he incluido 3 naves con pilotos de choques .  No serviran de mucho pero quizas [b][color=red]Alguien Especial[/color][/b] se una a ustedes en su travesia.\n Pero basta de chacharas, vamos a movernos!"
,"Ahora simulare una pared de asteroides. Es imposible de atravesarla para una nave convencional...  [b][color=#00FF00]Los asteroides dañaran cualquiera de tus naves que colisionen[/color][/b].\nAqui es donde entra en juego su [b][color=red]PODER[/color][/b] . ", 
"He incluido una  [b][color=#b2ffff]FORMACION[/color][/b] a la cadena de naves. Si en algun momento, ubican las naves haciendo esa formacion, [b][color=red]algo especial sucedera[/color][/b] ...."	, 
"Ahora, prueba formar una [b][color=#b2ffff]V invertida hacia adelante (>)[/color][/b] y luego apreten el boton ACTIVAR ([b][color=#00FF00]Barra espaciadora[/color][/b])  .",  
]

var ERROR_TEXT = ["Bueno, eso no salio muy bien, probemos otra vez"]

var texts_number = 0
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var obstacle_scene = preload("res://Scenery/Obstacle.tscn")
var rng = RandomNumberGenerator.new()
var spawner

var spawners = []
var time = 0

func start_segment():
	time = 15

	
func _on_SegmentTime_timeout():
	end_segment()
	print("Termine segmento")

func finish():
	print("Termine")
	var time = 10
	timer.start(time)
	add_asteroid_field(time)

func _ready():
	rng.randomize()
	var label = label_scene.instance()
	label.texts = TUTORIAL_TEXTS1
	add_child(label)
	label.connect("end_label",self,"finish")
	
	
func add_asteroid_field(duration):
	spawner = spawner_scene.instance()
	spawner.scene = obstacle_scene
	var vars = {"speed": -70,
				"rot_spd": rng.randi_range(2, 3)}
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 600
	spawner.start_time = 0
	spawner.duration = duration
	spawner.warning = false
	spawner.set_wait_time(0.1)
	add_child(spawner)


