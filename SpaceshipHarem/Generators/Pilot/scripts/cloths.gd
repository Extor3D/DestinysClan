tool
extends Sprite

enum Sprites {NONE,FEMALE01,FEMALE02,FEMALE03,FEMALE04,FEMALE05,FEMALE06,FEMALE07,FEMALE08,FEMALE09,FEMALE10,FEMALE11,
	MALE01,MALE02,MALE03,MALE04,MALE05,MALE06,MALE07}
const Male = Sprites.MALE01
const Female = Sprites.FEMALE01
const FILES = {
	Sprites.FEMALE01:"res://Generators/Pilot/images/cloths/female01.png",
	Sprites.FEMALE02:"res://Generators/Pilot/images/cloths/female02.png",
	Sprites.FEMALE03:"res://Generators/Pilot/images/cloths/female03.png",
	Sprites.FEMALE04:"res://Generators/Pilot/images/cloths/female04.png",
	Sprites.FEMALE05:"res://Generators/Pilot/images/cloths/female05.png",
	Sprites.FEMALE06:"res://Generators/Pilot/images/cloths/female06.png",
	Sprites.FEMALE07:"res://Generators/Pilot/images/cloths/female07.png",
	Sprites.FEMALE08:"res://Generators/Pilot/images/cloths/female08.png",
	Sprites.FEMALE09:"res://Generators/Pilot/images/cloths/female09.png",
	Sprites.FEMALE10:"res://Generators/Pilot/images/cloths/female10.png",
	Sprites.FEMALE11:"res://Generators/Pilot/images/cloths/female11.png",
	Sprites.MALE01:"res://Generators/Pilot/images/cloths/male01.png",
	Sprites.MALE02:"res://Generators/Pilot/images/cloths/male02.png",
	Sprites.MALE03:"res://Generators/Pilot/images/cloths/male03.png",
	Sprites.MALE04:"res://Generators/Pilot/images/cloths/male04.png",
	Sprites.MALE05:"res://Generators/Pilot/images/cloths/male05.png",
	Sprites.MALE06:"res://Generators/Pilot/images/cloths/male06.png",
	Sprites.MALE07:"res://Generators/Pilot/images/cloths/male07.png",
}

export(Sprites) var sprite:= Sprites.FEMALE01 setget set_sprite

func set_sprite(value: int) -> bool:
	if value==Sprites.NONE:
		sprite = value
		texture = null
		$Shadow.texture = null
		$Secondary.texture = null
		$Details.texture = null
		return true
	var path: String = FILES[value].split(".")[0]
	var ending: String = FILES[value].split(".")[1]
	var new_texture:= load(path+"_primary."+ending)
	if new_texture==null:
		printt(FILES[value]+"_primary."+ending+" not found!")
		return false
	sprite = value
	texture = new_texture
	if !is_inside_tree():
		return false
	new_texture = load(path+"_secondary."+ending)
	if new_texture==null:
		$Secondary.texture = null
	else:
		$Secondary.texture = new_texture
	new_texture = load(path+"_details."+ending)
	if new_texture==null:
		$Details.texture = null
	else:
		$Details.texture = new_texture
	new_texture = load(path+"_shadow."+ending)
	if new_texture==null:
		$Shadow.texture = null
	else:
		$Shadow.texture = new_texture
	return true
