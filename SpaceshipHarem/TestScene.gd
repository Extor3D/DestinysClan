extends Node2D


onready var generator = $BackgroundGenerator


# Called when the node enters the scene tree for the first time.
func _ready():
	var  new_size = Vector2(640,480)
	generator.rect_min_size = new_size
	generator.rect_size = new_size
	generator.set_mirror_size(new_size)
	generator.generate_new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
