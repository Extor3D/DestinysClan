extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_line($Ship1.position, $Ship2.position, Color.blueviolet)

func _process(delta):
	$SmallShip.position = (($Ship1.position - $Ship2.position) / 2) + $Ship2.position
	update()
