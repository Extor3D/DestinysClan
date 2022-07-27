tool
extends Sprite

enum Sprites {NEUTRAL01,NEUTRAL02,NEUTRAL03,FLAT01,FLAT02,ANGRY01,ANGRY02,SAD01,SAD02}
const FILES = {
	Sprites.NEUTRAL01:"res://Generators/Pilot/Generators/Pilot/images/brows/neutral01.png",
	Sprites.NEUTRAL02:"res://Generators/Pilot/images/brows/neutral02.png",
	Sprites.NEUTRAL03:"res://Generators/Pilot/images/brows/neutral03.png",
	Sprites.FLAT01:"res://Generators/Pilot/images/brows/flat01.png",
	Sprites.FLAT02:"res://Generators/Pilot/images/brows/flat02.png",
	Sprites.ANGRY01:"res://Generators/Pilot/images/brows/angry01.png",
	Sprites.ANGRY02:"res://Generators/Pilot/images/brows/angry02.png",
	Sprites.SAD01:"res://Generators/Pilot/images/brows/sad01.png",
	Sprites.SAD02:"res://Generators/Pilot/images/brows/sad02.png",
}

export(Sprites) var sprite:= Sprites.NEUTRAL01 setget set_sprite

func set_sprite(value: int) -> bool:
	var new_texture:= load(FILES[value])
	if new_texture==null:
		printt(FILES[value]+" not found!")
		return false
	sprite = value
	texture = new_texture
	return true
