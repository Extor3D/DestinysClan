extends Node2D

onready var parallax = $OnSurfOpen

export var camera_velocity: Vector2 = Vector2( -100, 0 );
 
 
func _process(delta: float) -> void:
	var new_offset: Vector2 = parallax.get_scroll_offset() + camera_velocity * delta
	parallax.set_scroll_offset( new_offset )
