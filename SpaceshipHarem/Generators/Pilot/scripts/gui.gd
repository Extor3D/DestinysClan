extends Control

const TYPES = ["Female","Male"]
const PARTS = ["Body","Cloths","Cloths/Neck","Mouth","Nose","Beard","Hair/Eyes","Hair/Brows","Hair/Eyes/Glasses","Hair","Hair/Front","BackHair","Hair/Details"]
const COLORS = [
	["#ffe6e2","#996b88","#4c335c"],
	["#cc8665","#4c335c","#0f0814"],
	["#e0f2f3","#6a7587","#181420"],
	["#eecc8c","#8c2a2a","#2a1722"],
	["#9682d9","#4c2f93","#381e78"],
	["#bf5656","#590e0e","#3e111a"],
	["#d099c8","#4c335c","#2a1722"],
	["#4b4b60","#181420","#181420"],
	["#a4dddb","#253a5e","#22264f"],
	["#788bbd","#253579","#22264f"],
	["#d0da91","#314829","#0a1a0d"],
	["#fdf5cc","#cc8665","#644133"],
	["#eecc8c","#644133","#2a1722"],
	["#f8a052","#61480d","#2a1722"],
	["#fbfefe","#5d807f","#2a1722"],
	["#7e787d","#61480d","#2a1722"], #Grey
	["#32a000","#112711","#112711"], #VerdeOscuro
	["#8a5339","#220d04","#112711"], #DarkBrown
	["#fbf2c5","#99966b","#112711"], #Olive	
	
	["#fde838","#000000","#000000"], #dummyYellow
]
const SHADOW_COLORS = [
	"#2a1722","#22264f","#181420","#4c335c","#0a1a0d"
]
const WHITE_COLOR = "#ffffff"
const BLACK_COLOR = "#0f0814"
const BUFFER_SIZE = 128

const DRAGS_NAME=["Claire Geeman","Thea Terre","Tira Mendus","Deedee Sign","Sasha Sass","Enna Fincible","Siam Pathy","Phara Waye","Selly Foxx","Juju Bee","Bella Lush","Sella Stice","Claire Rickal","Melody Gale","Mistress Galore","Noë Stalgia","Chichi Swank","Bea Constrictor","May Stirius","Sam Armie","Sia Gothic","Sara Donique","Anna Conda","Sofie Moore","Elle Lectrick","Sue Burben","Eva Siff","Jo Nee","Genna Russ","Liv Lee","Connie Fidence","Barba Rouse","Kaye Bye","Eve Forric","Penny Ramma","Miss Fortune","Lea Ness","Remi Nissent","Cecil Sunshine","Miss Sanguine","Lisse Truss","Raye Bitt","Ora Kelle","Sue Missif","Sia Dellic","Ella Gants","Raye Nessance","Lucy Luck","Vye Sual","Poppy Cox","Kitsch Kitsch Bang Bang","Maggie Magma","Super Nova"]
const FLAVOR_TEXT=[" Nada de terroristas de la gramática ,  frágiles emocionales ,  Drama Queens , incultas o de higiene dudosa (en negrita). No personas llamadas Florencia, ni tener una remera que diga 'te quiero pero soy un bardo' ni un tatuaje que diga 'soltar'.",
"Videos y fotitos para vos¡ Info x privado¡","Hola soy de Pollux 7. Tengo 27 años busco amistad y luego se ve", "Hola Buen dia a todos soy nuevite por aqui,  tengo 26 años y divorciade, busco chongo o lo que de","Me gusta viajar , el aire libre, reunirme para pasar buenos momentos. Deseo conocer gente que tenga buen humor y buenas energías"]

#const SPECIES = ["Gatashi","Diablo","Humano","Marciano","Androide"]
const SPECIES = [["Gatashi",[7,13,15],"Max HP",["Y","G"]],["Diablo",[5,6,4],"Speed",["O","X"]],	["Humano",[17,18,11],"Damage",["F1","F2"]],	["Marciano",[9,8,10,16],"Max Energy",["M","W"]],["Androide",[2,3,12,14],"Recovery Speed",["B1","B2"]]] 
const STATS = ["Max HP","Speed","Damage","Max Energy","Recovery Speed"]
const COMMON_FORMS = ["D","U","C","A","L"]

var buffer:= []
var buffer_index:= 0
var type: String = TYPES[0]

onready var portrait:= $Viewport/Portrait
onready var skin_material: ShaderMaterial = $Viewport/Portrait/Body.material
onready var primary_material: ShaderMaterial = $Viewport/Portrait/Cloths.material
onready var secondary_material: ShaderMaterial = $Viewport/Portrait/Cloths/Secondary.material
onready var detail_material: ShaderMaterial = $Viewport/Portrait/Cloths/Details.material
onready var eye_material: ShaderMaterial = $Viewport/Portrait/Hair/Eyes.material
onready var hair_material: ShaderMaterial = $Viewport/Portrait/Hair.material
onready var label:= $Label
onready var pilot_data:= $Pilot_data


func _randomize():
	
	# Seleccion de especie
	var pilot_specie = SPECIES[randi() % SPECIES.size()]
	var pilot_name = DRAGS_NAME[randi() % DRAGS_NAME.size()]
	var pilot_flavor = FLAVOR_TEXT[randi() % FLAVOR_TEXT.size()]

	# Si es humano
	var skin_color = max(randi()%3-1, 0)

	type = TYPES[randi() % TYPES.size()]
	
	## Completar
	var primary_color = randi()%COLORS.size()
	var secondary_color = randi()%COLORS.size()
	var eye_color = randi()%COLORS.size()
	var hair_color = randi()%COLORS.size()
	var shadow_color = SHADOW_COLORS[randi()%SHADOW_COLORS.size()]
	var data:= {
		"white_color":Color(WHITE_COLOR),
		"black_color":Color(BLACK_COLOR),
		"skin_light_color":Color(COLORS[skin_color][0]),
		"skin_dark_color":Color(COLORS[skin_color][1]),
		"skin_shadow_color":Color(COLORS[skin_color][2]),
		"primary_light_color":Color(COLORS[primary_color][0]),
		"primary_dark_color":Color(COLORS[primary_color][1]),
		"primary_shadow_color":Color(COLORS[primary_color][2]),
		"secondary_light_color":Color(COLORS[secondary_color][0]),
		"secondary_dark_color":Color(COLORS[secondary_color][1]),
		"secondary_shadow_color":Color(COLORS[secondary_color][2]),
		"detail_light_color":Color(COLORS[eye_color][0]),
		"detail_dark_color":Color(COLORS[eye_color][1]),
		"detail_shadow_color":Color(COLORS[eye_color][2]),
		"eye_light_color":Color(COLORS[eye_color][0]),
		"eye_dark_color":Color(COLORS[eye_color][1]),
		"eye_shadow_color":Color(shadow_color),
		"hair_light_color":Color(COLORS[hair_color][0]),
		"hair_dark_color":Color(COLORS[hair_color][1]),
		"hair_shadow_color":Color(COLORS[hair_color][2])
	}
	
	for part in PARTS:
		if portrait.get_node(part).get(type)!=null:
			var num: int = portrait.get_node(part).Sprites.size()-portrait.get_node(part).get(type)
			if TYPES.find(type)!=TYPES.size()-1:
				num = portrait.get_node(part).get(TYPES[TYPES.find(type)+1])
			if part == "Body":
				if pilot_specie[0] == "Androide":
					data[part] = 3
				else:
					data[part] = rand_range(1, 2)
			else:
				data[part] = randi()%num+portrait.get_node(part).get(type)
		else:
			data[part] = randi()%portrait.get_node(part).Sprites.size()
	if data.Hair==0:
		data.Hair = 1+randi()%(portrait.get_node("Hair").Sprites.size()-1)
	if type=="Male":
		data["Hair/Details"] = 0
		if randf()<0.1:
			data.Hair = 0
			data.BackHair = 0
			if randf()<0.75:
				data["Hair/Front"] = 0
		if randf()<0.5:
			data.Beard = 0
	elif type=="Female":
		data.Beard = 0
	if data.Cloths==0:
		data.Cloths = 1+randi()%(portrait.get_node("Cloths").Sprites.size()-1)
	data.brows_offset = randi()%3-1
	if randf()<0.75:
		data["Hair/Eyes/Glasses"] = 0
	if pilot_specie[0] == "Gatashi":
		data["Hair/Details"] = 2
	
	#if "android" in portrait.get_node("Body").Sprites.keys()[data.Body].to_lower() && randf()<0.5:
	var main_stat = pilot_specie[2]
	#Analizar si el stat tiene que ser diferente si o si
	var scd_stat = STATS[randi() % STATS.size()]	
	
	#Sacar esto
	var rarity = 5
	
	
	var pilot_stats = [[rarity/2,main_stat],[rarity/4,scd_stat]]
	var posible_colors = pilot_specie[1]
	skin_color =  posible_colors[randi() % posible_colors.size()]	
	var posible_formations = COMMON_FORMS
	#Mejorar el random?
	posible_formations.append_array(pilot_specie[3])
	var pilot_formation = posible_formations[randi() % posible_formations.size()]
	
	label.text = pilot_name
	pilot_data.add_text('\n' + "[b][color="+ str(COLORS[skin_color][0])+"]" + pilot_specie[0] + '[/color][/b]\n' )
	pilot_data.add_text('\n[wave]' + pilot_flavor + '[/wave]\n\n' + "Posicion Favorita: [rainbow freq=0.5 sat=10 val=20]" + pilot_formation + '[/rainbow]\n\n')
	
	pilot_data.add_text("[b]HÁBITOS | INTERESES[/b]" + '\n[rainbow freq=0.1]' + str(pilot_stats[0][1]) + " + " + str(pilot_stats[0][0]) + '[/rainbow]\n[rainbow freq=0.1]' + str(pilot_stats[1][1]) + " + " + str(pilot_stats[1][0]) + "[/rainbow]")

	
	while (main_stat == scd_stat): 
		scd_stat = STATS[randi() % STATS.size()]
	
	data.skin_light_color = Color(COLORS[skin_color][0])
	data.skin_dark_color = Color(COLORS[skin_color][1])
	data.skin_shadow_color = Color(COLORS[skin_color][2])
	buffer_index += 1
	buffer[buffer_index] = data
	if buffer_index>BUFFER_SIZE:
		buffer_index = 0
	
	set_portrait(data)

func set_portrait(data: Dictionary):
	# warning-ignore:shadowed_variable
	for type in PARTS:
		portrait.get_node(type).set_sprite(data[type])

	portrait.get_node("Hair/Brows").position.y = -data.brows_offset
	
	skin_material.set_shader_param("light_color", data.skin_light_color)
	skin_material.set_shader_param("dark_color", data.skin_dark_color)
	skin_material.set_shader_param("shadow_color", data.skin_shadow_color)
	skin_material.set_shader_param("white_color", data.white_color)
	skin_material.set_shader_param("black_color", data.black_color)
	primary_material.set_shader_param("light_color", data.primary_light_color)
	primary_material.set_shader_param("dark_color", data.primary_dark_color)
	primary_material.set_shader_param("shadow_color", data.primary_shadow_color)
	primary_material.set_shader_param("white_color", data.white_color)
	primary_material.set_shader_param("black_color", data.black_color)
	secondary_material.set_shader_param("light_color", data.secondary_light_color)
	secondary_material.set_shader_param("dark_color", data.secondary_dark_color)
	secondary_material.set_shader_param("shadow_color", data.secondary_shadow_color)
	secondary_material.set_shader_param("white_color", data.white_color)
	secondary_material.set_shader_param("black_color", data.black_color)
	detail_material.set_shader_param("light_color", data.detail_light_color)
	detail_material.set_shader_param("dark_color", data.detail_dark_color)
	detail_material.set_shader_param("shadow_color", data.detail_shadow_color)
	detail_material.set_shader_param("white_color", data.white_color)
	detail_material.set_shader_param("black_color", data.black_color)
	eye_material.set_shader_param("light_color", data.eye_light_color)
	eye_material.set_shader_param("dark_color", data.eye_dark_color)
	eye_material.set_shader_param("shadow_color", data.eye_shadow_color)
	eye_material.set_shader_param("white_color", data.white_color)
	eye_material.set_shader_param("black_color", data.black_color)
	hair_material.set_shader_param("light_color", data.hair_light_color)
	hair_material.set_shader_param("dark_color", data.hair_dark_color)
	hair_material.set_shader_param("shadow_color", data.hair_shadow_color)
	hair_material.set_shader_param("white_color", data.white_color)
	hair_material.set_shader_param("black_color", data.black_color)
	
func store_data():
	var data:= {
		"white_color":Color(WHITE_COLOR),
		"black_color":Color(BLACK_COLOR),
		"skin_light_color":Color(skin_material.get_shader_param("light_color")),
		"skin_dark_color":Color(skin_material.get_shader_param("dark_color")),
		"skin_shadow_color":Color(skin_material.get_shader_param("shadow_color")),
		"primary_light_color":Color(primary_material.get_shader_param("light_color")),
		"primary_dark_color":Color(primary_material.get_shader_param("dark_color")),
		"primary_shadow_color":Color(primary_material.get_shader_param("shadow_color")),
		"secondary_light_color":Color(secondary_material.get_shader_param("light_color")),
		"secondary_dark_color":Color(secondary_material.get_shader_param("dark_color")),
		"secondary_shadow_color":Color(secondary_material.get_shader_param("shadow_color")),
		"detail_light_color":Color(detail_material.get_shader_param("light_color")),
		"detail_dark_color":Color(detail_material.get_shader_param("dark_color")),
		"detail_shadow_color":Color(detail_material.get_shader_param("shadow_color")),
		"eye_light_color":Color(eye_material.get_shader_param("light_color")),
		"eye_dark_color":Color(eye_material.get_shader_param("dark_color")),
		"eye_shadow_color":Color(eye_material.get_shader_param("shadow_color")),
		"hair_light_color":Color(hair_material.get_shader_param("light_color")),
		"hair_dark_color":Color(hair_material.get_shader_param("dark_color")),
		"hair_shadow_color":Color(hair_material.get_shader_param("shadow_color")),
		"brows_offset":portrait.get_node("Hair/Brows").position.y
	}
	# warning-ignore:shadowed_variable
	for type in PARTS:
		data[type] = portrait.get_node(type).sprite
	
	buffer_index += 1
	buffer[buffer_index] = data
	if buffer_index>BUFFER_SIZE:
		buffer_index = 0

func _cycle_buffer(inc: int):
	var to:= int(fposmod(buffer_index+inc, BUFFER_SIZE))
	if buffer[to]==null:
		_randomize()
	else:
		buffer_index = to
		set_portrait(buffer[to])


func _set_sprite(ID: int, node: Node2D):
	node.set_sprite(ID)

func _cycle(node: Node2D, inc: int, button: OptionButton):
	var ID:= int(fposmod(node.sprite+inc, node.Sprites.size()))
	node.set_sprite(ID)
	button.selected = ID

func _set_type(ID: int):
	type = TYPES[ID]
	set_portrait(buffer[buffer_index])
	store_data()

func _cycle_type(inc: int, button: OptionButton):
	var ID: int = int(abs(TYPES.find(type)+inc))%TYPES.size()
	type = TYPES[ID]
	button.selected = ID
	set_portrait(buffer[buffer_index])
	store_data()

# warning-ignore:shadowed_variable
func _set_color(color: Color, material: String, type: String):
	get(material).set_shader_param(type, color)

# warning-ignore:shadowed_variable
func _set_bw_color(color: Color, type: String):
	skin_material.set_shader_param(type, color)
	eye_material.set_shader_param(type, color)
	hair_material.set_shader_param(type, color)
	primary_material.set_shader_param(type, color)
	secondary_material.set_shader_param(type, color)
	detail_material.set_shader_param(type, color)

func _set_neck_above_cloths(allowed: bool):
	portrait.get_node("Cloths/Neck").show_behind_parent = !allowed

func _set_eyes_above_hair(allowed: bool):
	portrait.get_node("Hair/Eyes").show_behind_parent = !allowed
	portrait.get_node("Hair/Eyes").raise()
	if !allowed:
		portrait.get_node("Hair/Front").raise()

func _set_brows_above_hair(allowed: bool):
	portrait.get_node("Hair/Brows").show_behind_parent = !allowed
	portrait.get_node("Hair/Brows").raise()
	if !allowed:
		portrait.get_node("Hair/Front").raise()

func _set_brows_offset(value: int):
	portrait.get_node("Hair/Brows").position.y = -value

func _resized():
	var scale:= int(max(5.0*min((OS.window_size.x-60)/1024.0, 1.5*(OS.window_size.y-130)/600.0), 1))
	$Portrait.rect_size = 96*scale*Vector2(1.0,1.0)

func _ready():
	randomize()
	buffer.resize(BUFFER_SIZE)
	_resized()
	get_tree().connect("screen_resized", self, "_resized")
	
	_randomize()
