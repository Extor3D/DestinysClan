extends Node2D
class_name Segment

signal last_segment
signal segment_ended(number)

export(int, 1, 10) var difficulty = 1

var number : int

func start_segment():
	pass

func end_segment():
	emit_signal("segment_ended", number)
