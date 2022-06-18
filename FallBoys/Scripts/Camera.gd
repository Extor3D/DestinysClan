extends Camera2D

export(NodePath) var follow

onready var fol = get_node(follow)

func _process(delta):
	position = fol.position
