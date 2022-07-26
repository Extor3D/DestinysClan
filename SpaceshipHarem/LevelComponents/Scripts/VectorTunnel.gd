extends Node2D
class_name VectorTunnel

enum types {TOP = 1, BOT = 2, BOTH = 3}
const NO_END = -1

export (types) var type
export (float) var start_time
export (float) var duration
export (float) var new_vert_time = 1
export (float) var tunnel_speed = 50
export (float) var tunnel_size
export (float) var top = 100
export (float) var low = 260
export (float) var y = 180
export (float) var step_min = -30
export (float) var step_max = 30
export (Texture) var top_texture
export (Texture) var bot_texture

var x_left = -200
var x_right = 840

var draw_bot = false
var draw_top = false

var opening_finish = false
var end_tunnel = false

var polygon_top : Array
var polygon_bot : Array

var rng = RandomNumberGenerator.new()

func _ready():
	match type:
		types.TOP:
			draw_top = true
			draw_bot = false
			$TunnelBot.queue_free()
		types.BOT:
			draw_bot = true
			draw_top = false
			$TunnelTop.queue_free()
		types.BOTH:
			draw_top = true
			draw_bot = true
	
	rng.randomize()
	$StartTime.start(start_time)
	if draw_top:
		polygon_top.append(Vector2(x_right + 50, y - tunnel_size/2))
		polygon_top.append(Vector2(x_right - 50, -10))
		polygon_top.append(Vector2(x_right, -100))
		polygon_top.append(Vector2(x_right, y - tunnel_size/2))
		$TunnelTop/TunnelView.texture = top_texture
		set_array(polygon_top, $TunnelTop)
	
	if draw_bot:
		polygon_bot.append(Vector2(x_right + 50, y + tunnel_size/2))
		polygon_bot.append(Vector2(x_right - 50, 460))
		polygon_bot.append(Vector2(x_right, 460))
		polygon_bot.append(Vector2(x_right, y + tunnel_size/2))
		$TunnelBot/TunnelView.texture = bot_texture
		set_array(polygon_bot, $TunnelBot)
	
func _process(delta):
	if draw_top:
		if not opening_finish:
			move_start($TunnelTop, polygon_top, delta)
		move_polygon($TunnelTop, polygon_top, delta)
		move_texture($TunnelTop, delta)
	if draw_bot:
		if not opening_finish:
			move_start($TunnelBot, polygon_bot, delta)
		move_polygon($TunnelBot, polygon_bot, delta)
		move_texture($TunnelBot, delta)

func move_texture(tunnel, delta):
	var off = tunnel.get_node("TunnelView").texture_offset + Vector2(tunnel_speed * delta, 0)
	tunnel.get_node("TunnelView").texture_offset = off

func move_start(tunnel, pol, delta):
	move_range(pol, 0, 2, 1, delta)	
	var vert = pol[0]
	if vert.x < x_left - 300:
		opening_finish = true
	set_array(pol, tunnel)

func move_polygon(tunnel, pol, delta):
	var end = 3
	if end_tunnel:
		end = -1
	move_range(pol, pol.size()-1, end, -1, delta)
	for i in range(pol.size()-1, end, -1):
		var vert = pol[i]
		if vert.x < x_left and not end_tunnel:
			pol.remove(i)
	set_array(pol, tunnel)
	
func move_range(pol, start, end, step, delta):
	for i in range(start, end, step):
		var vert = pol[i]
		vert.x -= delta * tunnel_speed
		pol[i] = vert
	
func _on_StartTime_timeout():
	$BetweenVerts.start(new_vert_time)
	if duration != NO_END:
		$EndTime.start(duration)

func _on_EndTime_timeout():
	end_tunnel = true
	if draw_top:
		close_tunnel($TunnelTop, polygon_top, -10)
	if draw_bot:
		close_tunnel($TunnelBot, polygon_bot, 370)
	$BetweenVerts.set_paused(true)
	
func close_tunnel(tunnel, pol, pos_y):
	var vert = pol[3]
	vert.y = pos_y
	vert.x += 100
	pol[3] = vert
	set_array(pol, tunnel)

func _on_BetweenVerts_timeout():
	if draw_top:
		add_vert_to_pol($TunnelTop, polygon_top, y - tunnel_size/2)
	if draw_bot:
		add_vert_to_pol($TunnelBot, polygon_bot, y + tunnel_size/2)
	y = clamp(y + rng.randi_range(step_min, step_max), top, low)
	
func add_vert_to_pol(tunnel, pol, next_y):
	pol.insert(4, Vector2(x_right, next_y))
	set_array(pol, tunnel)
	
func set_array(array: Array, tunnel: Node2D):
	tunnel.get_node("TunnelView").set_polygon(PoolVector2Array(array))
	tunnel.get_node("TunnelBody/TunnelCollision").set_polygon(PoolVector2Array(array))
	
