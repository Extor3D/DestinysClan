extends Node2D
class_name Segment

export(int, 1, 10) var difficulty = 1
export(NodePath) var next_segment : NodePath

onready var next : Segment = get_node_or_null(next_segment)

func start_segment():
	pass

func end_segment():
	if next != null:
		next.start_segment()
	else:
		#end level
		pass
