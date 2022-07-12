extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#If the Player is still alive, we get the energy from it
	if get_parent().has_node("Player"):
		$Label.text = str(get_parent().get_node("Player").energy)
