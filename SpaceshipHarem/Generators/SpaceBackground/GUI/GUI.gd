extends Control


onready var generator = $Viewport/BackgroundGenerator
onready var viewport = $Viewport
onready var global_scheme = preload("res://Generators/SpaceBackground/BackgroundGenerator/Colorscheme.tres")

var new_size = Vector2(200,200)

func _ready():
	randomize()
	_generate_new()

func _generate_new():
	$Viewport.size = new_size
	generator.rect_min_size = new_size
	generator.rect_size = new_size
	generator.set_mirror_size(new_size)
	$Viewport/Camera1.zoom = new_size/viewport.size
	$Viewport/Camera1.offset = new_size * 0.5
	
	var aspect = Vector2(1,1)
	if new_size.x > new_size.y:
		aspect = Vector2(new_size.y / new_size.x, 1.0)
	else:
		aspect = Vector2(1.0, new_size.x / new_size.y)
	
	$HBoxContainer/Control/TextureRect.rect_size = aspect * 600

	yield(get_tree(), "idle_frame")
	$HBoxContainer/Control/TextureRect.rect_size = Vector2(600,600)
	generator.generate_new()

func _on_NewButton_pressed():
	_generate_new()

func _on_ExportButton_pressed():
	$Viewport/Camera1.current = false
	$Viewport/Camera2.current = true
	$SaveTimer.start()

func export_image():
	var img = Image.new()
	img.create(new_size.x, new_size.y, false, Image.FORMAT_RGBA8)
	var viewport_img = viewport.get_texture().get_data()
	
	img.blit_rect(viewport_img, Rect2(0,0,new_size.x,new_size.y), Vector2(0,0))
	
	save_image(img)

func save_image(img):
	if OS.get_name() == "HTML5" and OS.has_feature('JavaScript'):
		var filesaver = get_tree().root.get_node("/root/HTML5File")
		filesaver.save_image(img, "Space Background")
	else:
		img.save_png("res://Generators/SpaceBackground/Space Background.png")

func _on_SaveTimer_timeout():
	export_image()
	$Viewport/Camera1.current = true
	$Viewport/Camera2.current = false

func select_colorscheme(scheme):
	$Viewport/BackgroundGenerator.set_background_color(scheme[0])
	scheme.remove(0)
	global_scheme.gradient.colors = scheme

func _on_EnableStars_pressed():
	generator.toggle_stars()

func _on_EnableDust_pressed():
	generator.toggle_dust()

func _on_EnableNebulae_pressed():
	generator.toggle_nebulae()

func _on_EnablePlanets_pressed():
	generator.toggle_planets()

func _on_EnableReduceBackground_pressed():
	generator.toggle_reduce_background()

func _on_EnableTile_pressed():
	generator.toggle_tile()

func _on_PixelsHeight_value_changed(value):
	value = clamp(value, 100, 3000)
	new_size.y = int(value)

func _on_PixelsWidth_value_changed(value):
	value = clamp(value, 100, 3000)
	new_size.x = int(value)


func _on_EnableTransparency_pressed():
	generator.toggle_transparancy()
