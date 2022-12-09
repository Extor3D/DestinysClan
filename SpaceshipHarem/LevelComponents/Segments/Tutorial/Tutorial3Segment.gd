extends Segment

onready var timer = $SegmentTime3
onready var playernode = get_parent().get_parent().get_child(1)
var label_scene = preload("res://UI/Screens/bblabelUI.tscn")

var TUTORIAL_TEXTS3 = ["Grandioso!!!\n Estan casi listos para salir al espacio. Acabo de activar sus armas en automatico, para que se concentren en maniobrar la nave.",
"Habran notado que en la parte superior de su pantalla, justo en el medio, hay 3 indicadores que pasan de [b][color=green]verde[/color][/b] a [b][color=yellow]amarillo[/color][/b].\nEsto indica el segmento del nivel. El segmento activo se muestra en [b][color=yellow]amarillo[/color][/b] para indicar que lugar te encuentras.",
"La barra de arriba a la izquierda [b][color=#00FF00]representa la vida de la formacion[/color][/b], recuerdalo todas las naves comparten vitalidad.",
"La barra justo debajo de ella es la [b][color=aliceblue]representa la energia y se llena automaticamente[/color][/b].\nAlgunos enemigos en lugar de los disparos regulares(rojos),lanzaran disparos azules.\nEstos disparos, al impactar en la [b][color=red]CADENA[/color][/b] [b][color=#00FF00]recargaran tu energia![/color][/b].",
"Se que es mucha informacion junta, pero prometo que es la ultima! Si encuentras una posicion que te beneficie, puedes mantener [b][color=#00FF00]SHIFT[/color][/b] para que tus naves se mantengan asi.",
"Simulare otro grupo de enemigos, trata de cargar tu energia al maximo mientras esquivas. "]

var BOSS_TEXTS = [
	"En su aventura visitaran varios planetas y lamentablemente, estan fuertemente armados.\nEs probable que se topen tarde o temprano con una [b][color=green]nave imperial[/color][/b].",
"Las naves imperiales [b][color=#00FF00]tienen una gran variedad de armas y son mucho mas resistentes[/color][/b] que las naves normales.\nGeneralmente sera la ultima linea de defensa que tiene un planeta. ",
"Simulare una de estas naves para que aprendan a lidiar con ellas.\nHe instalado un Software Pirata para detectar el estado de esas naves.\nLa Barra que esta arriba a la derecha [b][color=#00FF00]indica la salud del enemigo final[/color][/b]. ",
"Bueno, eso es todo por ahora...\nDerrota al jefe usando lo aprendido. [b][color=#00FF00]Recuerda que todos los disparos que te dañan son de color rojo.[/color][/b]\nMucha suerte!!"
]

var texts_number = 0
var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var primary_enemy_scene = preload("res://Enemies/Bosses/RandomBoss.tscn")

var spawners = []
var time = 0

var rng = RandomNumberGenerator.new()
var ended3 = false
var label = label_scene.instance()


func start_segment():
	playernode.start_shooting()
	time = 1
	label.texts = TUTORIAL_TEXTS3
	var Chars_Speaking = [Global.Char_Kokoro,Global.Char_Kokoro,Global.Char_Kokoro,Global.Char_Kokoro,Global.Char_Kokoro,Global.Char_Kokoro,Global.Char_Kokoro]
	label.character_img = Chars_Speaking
	add_child(label)
	label.connect("end_label",self,"finish")

	
func _on_SegmentTime_timeout():
	ended3 = true
	end_segment()

func finish():
	if !ended3:
		timer.start(time)
		remove_child(label)

func _ready():
	rng.randomize()

