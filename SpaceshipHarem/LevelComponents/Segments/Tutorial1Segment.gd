extends Segment

onready var timer = $SegmentTime
onready var container = $UI/Container
onready var label = $UI/Container/Label
onready var button = $UI/Button

var TUTORIAL_TEXTS_PREV = ["Bienvenidos al [b]Simulador de batalla[/b].\nAqui les enseñare lo basico, aunque seguramente no lo necesiten. Todos aqui somos veteranos de las guerras conicas verdad? no?\nEste es un momento muy incomodo para todos asi que como dicen 'Al mal paso darle prisa' ",
"[b][color=#ffc0cb]Alpha[/color][/b], he configurado los controles de tu nave segun tus  preferencias (Esta nave se controla con [b][color=#00FF00]WASD[/color][/b]).", 
"En tu caso [b][color=yellow]Omega[/color][/b] , hemos vuelto a los controles basicos, se que no tendras quejas (Esta nave se controla con las [b][color=#00FF00]flechas[/color][/b]) . Se conocen hace mucho y los une un [b][color=red]VINCULO[/color][/b] muy estrecho, asi que creo que no hacen falta las presentaciones despues de todo."	, 
"Se preguntaran que son esas naves del medio...  Es un experimento que he estado planificando, si tiene exito en el simulador, lo podremos trasladar a naves reales!\nEsas 3 naves son [b][color=#FFD700]Naves Conectoras[/color][/b] .",  
"Cuando una nave une a la formacion entre las naves de ustedes 2 forma una [b][color=red]Cadena[/color][/b] . Esta cadena liberara todo su potencial. Por ahora he incluido 3 naves con pilotos de choques .  No serviran de mucho pero quizas [b][color=red]Alguien Especial[/color][/b] se una a ustedes en su travesia.\n Pero basta de chacharas, vamos a movernos!"
]

var TUTORIAL_TEXTS_2 = ["Ahora simulare una pared de asteroides. Es imposible de atravesarla para una nave convencional...  [b][color=#00FF00]Los asteroides dañaran cualquiera de tus naves que colisionen[/color][/b].\nAqui es donde entra en juego su [b][color=red]PODER[/color][/b] . ", 
"He incluido una  [b][color=#b2ffff]FORMACION[/color][/b] a la cadena de naves. Si en algun momento, ubican las naves haciendo esa formacion, [b][color=red]algo especial sucedera[/color][/b] ...."	, 
"Ahora, prueba formar una [b][color=#b2ffff]V invertida hacia adelante (>)[/color][/b] y luego apreten el boton ACTIVAR ([b][color=#00FF00]Barra espaciadora[/color][/b])  .",  
"Bueno, eso no salio muy bien, probemos otra vez"]

var TUTORIAL_TEXTS3 = ["Excelente!!! Sabia que lo lograrian! \nVan entendiendo como funciona su [b][color=red]PODER[/color][/b].\nHay una ventaja adicional... a diferencia de los asteroides, las naves y disparos enemigos, [b][color=#00FF00]no dañan a tus naves conectoras, esa es otra ventaja de la cadena.[/color][/b]",
"Habras notado que he configurado tus armas en automatico,por lo que  [b][color=#00FF00]tus naves disparan todo el tiempo[/color][/b] . ", 
"Probemos nuevamente, simulare algunos enemigos ,recuerda que [b][color=#00FF00]los disparos y las naves solo dañan tu primera y ultima nave[/color][/b].\nLo importante aqui es esquivar, no necesitas encargarte de todos los enemigos." ]

var TUTORIAL_TEXTS = ["Grandioso!!! Otro exito!\n Estan casi listos para salir al espacio.",
"En su aventura visitaran varios planetas y lamentablemente, estan fuertemente armados.\nEs probable que se topen tarde o temprano con una [b][color=green]nave imperial[/color][/b].",
"Las naves imperiales [b][color=#00FF00]estan fuertemente armadas y son mucho mas resistentes[/color][/b] que las naves normales.\nGeneralmente sera la ultima linea de defensa que tiene un planeta. ",
"Simulare una de estas naves para que aprendan a lidiar con ellas.\nMucha suerte!!"]

var texts_number = 0
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/BeeEnemy.tscn")
var secondary_enemy_scene = preload("res://Enemies/Enemy.tscn")
var tertiary_enemy_scene = preload("res://Enemies/Enemy2.tscn")

var types = [
[{"xspeed": -70 - difficulty*3,"cadence":100,"rotation_degrees": 0},[150,-50,50,50],"DI"], # Derecha a izq
[{"xspeed": 70  + difficulty*3,"cadence":100,"rotation_degrees": 180},[300,650,50,50],"ID"], #  Izq a Der
[{"yspeed": 70 + difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 90},[550,550,50,50],"HAR"], # Hacia Arriba
[{"yspeed": -70  -difficulty*3,"xspeed": 10 ,"cadence":100,"rotation_degrees": 270},[-50,50,50,50],"HAB"], # Hacia Abajo
[{"yspeed": -70  -difficulty*3,"xspeed": -70 ,"cadence":100,"rotation_degrees": 45},[-50,-50,50,50],"DIAG1"],
[{"yspeed": -70  -difficulty*3,"xspeed": 70 ,"cadence":100,"rotation_degrees": 135},[-50,550,50,50],"DIAG2"],
[{"yspeed": 70  -difficulty*3,"xspeed": 70 ,"cadence":100,"rotation_degrees": 225},[400,650,50,50],"DIAG3"],
[{"yspeed": 70  -difficulty*3,"xspeed": -70 ,"cadence":100,"rotation_degrees": 315},[400,-50,50,50],"DIAG4"]
]

var spawners = []

var rng = RandomNumberGenerator.new()

func start_segment():
	var time = 15 + difficulty * 2
	spawners.append(add_enemy_group(time/3,3,primary_enemy_scene))
	spawners.append(add_enemy_group(time/3,time/3,secondary_enemy_scene))
	spawners.append(add_enemy_group(time/3,time * 2/3,tertiary_enemy_scene))
	timer.start(time)
	
func _on_SegmentTime_timeout():
	end_segment()

	
func _ready():
	rng.randomize()
	label.text = ""
	label.add_text(TUTORIAL_TEXTS[0])
	
	
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

func manage_text():
	if (texts_number < TUTORIAL_TEXTS.size() -1):
		texts_number += 1
		label.text = ""
		label.add_text(TUTORIAL_TEXTS[texts_number])
	else:
		container.visible = false
		button.visible = false
		start_segment()
		
func _on_Button_pressed():
	manage_text()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			manage_text()
