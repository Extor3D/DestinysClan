extends Node2D

const DRAGS_NAME=["Claire Geeman","Thea Terre","Tira Mendus","Deedee Sign","Sasha Sass","Enna Fincible","Siam Pathy","Phara Waye","Selly Foxx","Juju Bee","Bella Lush","Sella Stice","Claire Rickal","Melody Gale","Mistress Galore","Noë Stalgia","Chichi Swank","Bea Constrictor","May Stirius","Sam Armie","Sia Gothic","Sara Donique","Anna Conda","Sofie Moore","Elle Lectrick","Sue Burben","Eva Siff","Jo Nee","Genna Russ","Liv Lee","Connie Fidence","Barba Rouse","Kaye Bye","Eve Forric","Penny Ramma","Miss Fortune","Lea Ness","Remi Nissent","Cecil Sunshine","Miss Sanguine","Lisse Truss","Raye Bitt","Ora Kelle","Sue Missif","Sia Dellic","Ella Gants","Raye Nessance","Lucy Luck","Vye Sual","Poppy Cox","Kitsch Kitsch Bang Bang","Maggie Magma","Super Nova"]
const SPACE_NAME=["Astro Labe","Luther Nova"]
const CAT_NAMES =["Devon Rex","Maine Coon","Reggie Doll","Sphynx Eas","Percy Ann","Amy Sinian"]
const DIABLO_NAMES =["Starel","Galaxyel","Novael"]
const OTHER_NAME=["Rene Gado","Sasha Mado","Ariel Ganado","Connie Modo", "Andrea Eaeaea" , "Charlie Mon",
"Mary Sue", "Gary Stu"]

# Pasar al archivo de Idiomas
# Ajustar de acuerdo al Lore
const OCCUPATION=["Estudiante","Monotributista","Experto en Cosas","Alma Libre",
"Freelancer","Soy mi Propio Jefe","Arreglo Monopatines por deporte","Tu Media Naranja","De la universidad de la vida","Casi-Influencer","Contador de Estrellas"]

const FLAVOR_TEXT=[" Nada de terroristas de la gramática, frágiles emocionales, Drama Queens, incultxs o de higiene dudosa. No personas llamadas Florencia, ni tener una remera que diga 'te quiero pero soy un bardo' ni un tatuaje que diga 'soltar'.",
"Videos y fotitos para vos! Info x privado!","Hola soy de Pollux 7. Tengo 27 años busco amistad y luego se ve", "Hola Buen dia a todos soy nuevite por aqui, tengo 26 años y divorciade, busco chongo o lo que de","Me gusta viajar, el aire libre, reunirme para pasar buenos momentos. Deseo conocer gente que tenga buen humor y buenas energías"]


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


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var portrait = $Portrait
onready var skin_material: ShaderMaterial = $Portrait/Body.material
onready var primary_material: ShaderMaterial = $Portrait/Cloths.material
onready var secondary_material: ShaderMaterial = $Portrait/Cloths/Secondary.material
onready var detail_material: ShaderMaterial = $Portrait/Cloths/Details.material
onready var eye_material: ShaderMaterial = $Portrait/Hair/Eyes.material
onready var hair_material: ShaderMaterial = $Portrait/Hair.material


var type: String = TYPES[0]

func create_random_data():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	# Seleccion de especie
	var pilot_specie = Global.SPECIES[randi() % Global.SPECIES.size()]
	var posible_names = DRAGS_NAME
	posible_names.append_array(SPACE_NAME)
	posible_names.append_array(OTHER_NAME)
	var pilot_name = posible_names[randi() % posible_names.size()]
	var pilot_flavor = FLAVOR_TEXT[randi() % FLAVOR_TEXT.size()]
	var skin_color = 0

	type = TYPES[randi() % TYPES.size()]
	
	## Completar
	var primary_color = rng.randi() %COLORS.size()
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
		data["Hair/Front"] = 13
	elif pilot_specie[0] == "Diablo":
		data["Hair/Front"] = 14
	elif data["Hair/Front"] >= 13:
		data["Hair/Front"] = rand_range(0,12)
	
	#if "android" in portrait.get_node("Body").Sprites.keys()[data.Body].to_lower() && randf()<0.5:
	var main_stat = pilot_specie[2]
	var main_stat_name = Global.get_stat_by_id(main_stat).name
	#Analizar si el stat tiene que ser diferente si o si
	var scd_stat = Global.STAT_NAMES.values()[randi() % Global.STAT_NAMES.size()]
	#var scd_stat = STATS[randi() % STATS.size()]
	while (main_stat == scd_stat): 
		scd_stat = Global.STAT_NAMES.values()[randi() % Global.STAT_NAMES.size()]
	
	var scd_stat_name = Global.get_stat_by_id(scd_stat).name
	#Sacar esto
	var rarity = Global.current_difficulty #Legendary: 6
	var plus = 0
	if (int(rarity) % 2) == 1:
		plus += 1
	
	
	var pilot_stats = [[(rarity/2 + plus  ),main_stat],[floor(rarity/2),scd_stat]]
	var posible_colors = pilot_specie[1]
	skin_color =  posible_colors[randi() % posible_colors.size()]	
	var posible_formations = Global.COMMON_FORMS
	
	#Mejorar el random?
	# TAPADO PARA LA DEMO
	#posible_formations.append_array(pilot_specie[3])
	var pilot_formation = posible_formations[randi() % posible_formations.size()]
	var pilot_formation_desc = tr(Global.get_form_by_id(pilot_formation).name)
	
	# PERFIL DEL CANDIDATO
	var pilot_age = int(rand_range(18,39))
	var pilot_distance = stepify(rand_range(45,95), 0.01)
	var pilot_occupation = OCCUPATION[randi() % OCCUPATION.size()]
	
	
	# ARMAR EL RETRATO
	var pilot_skin_color = Color(COLORS[skin_color][0])
	
	data.skin_light_color = pilot_skin_color
	data.skin_dark_color = Color(COLORS[skin_color][1])
	data.skin_shadow_color = Color(COLORS[skin_color][2])
	data.age = pilot_age
	data.distance = pilot_distance
	data.occupation = pilot_occupation
	data.name = pilot_name
	data.flavor = pilot_flavor
	data.formation = pilot_formation
	data.formation_desc = pilot_formation_desc
	data.color = Color(COLORS[hair_color][0])
	data.stats = pilot_stats
	data.specie = pilot_specie[0]

	return data


func set_data(data: Dictionary):
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

