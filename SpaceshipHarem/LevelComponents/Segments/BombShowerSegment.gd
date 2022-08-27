extends Segment

onready var timer = $SegmentTime
onready var bomb_timer = $BombSpawnTimer

var rng = RandomNumberGenerator.new()
var bomb : PackedScene = preload("res://Enemies/Weapons/EnemyBomb.tscn")

var rad = 30
var warn_time = 1

func start_segment():
	rng.randomize()
	var time = 15 + difficulty * 2
	var bomb_time = 1 - float(difficulty)/12
	rad = 60 - difficulty * 2
	timer.start(time)
	bomb_timer.start(bomb_time)

func _on_SegmentTime_timeout():
	bomb_timer.stop()
	end_segment()


func _on_BombSpawnTimer_timeout():
	var b = bomb.instance()
	b.global_position = Vector2(800, -100)
	b.final_pos = Vector2(rng.randi_range(10, 630), rng.randi_range(10, 350))
	b.warn_time = warn_time
	b.radius = rad
	add_child(b)
