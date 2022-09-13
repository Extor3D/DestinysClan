extends Segment

var spawner_scene = preload("res://LevelComponents/Spawner.tscn")
var bullet_hell_scene = preload("res://Enemies/BulletHellEnemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_segment():
	add_hell_sub_boss()

func add_hell_sub_boss():
	var spawner = spawner_scene.instance()
	spawner.scene = bullet_hell_scene
	var vars = {"speed": 100,
				"health": 50 + difficulty * 10,
				"difficulty": difficulty }
	spawner.scene_variables = vars
	spawner.y_center = 180
	spawner.height = 1
	spawner.start_time = 0
	spawner.duration = 1
	spawner.warning = false
	spawner.set_wait_time(0.8)
	spawner.start_on_ready = true
	add_child(spawner)
	spawner.connect("spawner_cleared", self, "end_segment")
