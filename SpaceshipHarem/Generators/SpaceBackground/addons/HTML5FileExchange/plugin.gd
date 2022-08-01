tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("HTML5File", "res://Generators/SpaceBackground/addons/HTML5FileExchange/HTML5FileExchange.gd")


func _exit_tree():
	remove_autoload_singleton("HTML5File")
