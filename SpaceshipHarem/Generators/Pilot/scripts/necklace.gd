tool
extends Sprite

enum Sprites {NONE,NECKLACE,COLLAR,BOW,TIE,SCARF}
const FILES = {
	Sprites.NECKLACE:"res://Generators/Pilot/images/neck/necklace.png",
	Sprites.COLLAR:"res://Generators/Pilot/images/neck/collar.png",
	Sprites.BOW:"res://Generators/Pilot/images/neck/bow.png",
	Sprites.TIE:"res://Generators/Pilot/images/neck/tie.png",
	Sprites.SCARF:"res://Generators/Pilot/images/neck/scarf.png",
}

export(Sprites) var sprite:= Sprites.NONE setget set_sprite

func set_sprite(value: int) -> bool:
	if value==Sprites.NONE:
		sprite = value
		texture = null
		return true
	var new_texture:= load(FILES[value])
	if new_texture==null:
		printt(FILES[value]+" not found!")
		return false
	sprite = value
	texture = new_texture
	return true
