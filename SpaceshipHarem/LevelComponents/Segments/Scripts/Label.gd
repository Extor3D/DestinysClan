extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rect_size.x = 400 # Replace with function body.

func add_text(text_to_add):
	append_bbcode(text_to_add)
