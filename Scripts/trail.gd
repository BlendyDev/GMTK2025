extends StaticBody2D
class_name Trail

class Combo:
	var count: int
	var mobs: Array[Mob]

@onready var level: Level = $".."
@onready var trail_line: Line2D = $Trail
@onready var player: Player = $"../Player"
@onready var loop_scene = preload("res://Scenes/loop.tscn")
@onready var combo_scene = preload("res://Scenes/combo.tscn")

@export var trail_points_per_second: int = 120
@export var max_trail_time_sec: float = 1.15
@export var min_distance_to_oldest_points: float
@export var circle_min_timeout_sec: float
@export var last_points_tolerance := 0.2
@export var freeze_time := 0.06
@export var time_per_death_handle_sec: float = 0.1
@export var circle_lifetime: float = 0.05

var time_since_last_point_sec := 0.0
var time_since_last_circle_sec := 0.0
var time_since_last_death_handle := 0.0
var cleared_points = true
var trail_collisions: Array[CollisionShape2D]
var can_trail = true
var dead_mobs: Array[Mob] = []
var combos: Array[Combo] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_since_last_circle_sec = 0.0
	pass # Replace with function body.

func find_closest_point(rate: float) -> Vector2:
	var point: Vector2
	var distance:float = INF
	for i in range (min(trail_line.points.size(), ceil(rate*max_trail_time_sec*trail_points_per_second))):
		var current_point := trail_line.points.get(i)
		var current_dist := player.position.distance_to(current_point)
		if (current_dist < distance):
			distance = current_dist
			point = current_point
	return point

func simplify_polygon(polygon: PackedVector2Array) -> Array[PackedVector2Array]:
	return Geometry2D.merge_polygons(polygon, PackedVector2Array([]))

func animate_fail_trail():
	var failed_trail = Line2D.new()
	failed_trail.antialiased = true
	failed_trail.width = 4.0
	failed_trail.default_color = Color.from_rgba8(199, 66, 79, 255)
	failed_trail.points = trail_line.points.duplicate()
	failed_trail.joint_mode = Line2D.LINE_JOINT_ROUND
	failed_trail.begin_cap_mode = Line2D.LINE_CAP_ROUND
	failed_trail.end_cap_mode = Line2D.LINE_CAP_ROUND
	failed_trail.closed = false
	failed_trail.points = trail_line.points.duplicate()
	failed_trail.z_index = 50
	var tween = get_tree().create_tween()
	tween.tween_property(failed_trail, "width", 0, 0.4)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_callback(failed_trail.queue_free)
	get_tree().current_scene.add_child(failed_trail)

func reset_trail():
	cleared_points = true
	time_since_last_circle_sec = 0.0
	for collision_shape in trail_collisions:
		collision_shape.queue_free()
	trail_collisions.clear()
	trail_line.clear_points()


func try_spawn_circle(closest_point: Vector2):
	if (player.velocity.length() < 20.0): 
		reset_trail()
		AudioController.cut_tail_sfx()
		return
	AudioController.circle_sfx()
	AudioController.arpeggio_sfx()
	var fade_out_trail = Line2D.new()
	fade_out_trail.antialiased = true
	fade_out_trail.width = 6.0
	fade_out_trail.default_color = Color.from_rgba8(252, 239, 141, 255)
	fade_out_trail.points = trail_line.points.duplicate()
	fade_out_trail.joint_mode = Line2D.LINE_JOINT_ROUND
	fade_out_trail.begin_cap_mode = Line2D.LINE_CAP_ROUND
	fade_out_trail.end_cap_mode = Line2D.LINE_CAP_ROUND
	fade_out_trail.z_index = 50
	for i in range(trail_line.points.size()):
		if (fade_out_trail.points.get(0) == closest_point): break
		fade_out_trail.remove_point(0)
		
	fade_out_trail.add_point(closest_point)
	var area = Area2D.new()
	area.collision_layer = pow(2, 10-1)
	area.collision_mask = pow(2, 3-1)
	
	var initial_polygon :PackedVector2Array = fade_out_trail.points.duplicate()
	var polygons := simplify_polygon(initial_polygon)
	for polygon in polygons:
		var collision = CollisionPolygon2D.new()
		collision.polygon = polygon
		area.add_child(collision)
	var loop_count = polygons.size()
	if (loop_count > 1):
		var loop := loop_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(loop)
		loop.position = player.position
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out_trail, "width", 0, 0.8)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_callback(fade_out_trail.queue_free)
	get_tree().current_scene.add_child(fade_out_trail)
	destroy_circle_async(area)
	get_tree().current_scene.add_child(area)
	reset_trail()

func destroy_circle_async(area: Area2D):
	await get_tree().create_timer(circle_lifetime).timeout
	area.queue_free()

func add_point():
	var n = floor((time_since_last_point_sec) / (1.0/trail_points_per_second))
	var points: Array[Vector2]
	var last_position: Vector2
	if (trail_line.points.size() == 0): last_position = player.position
	else: last_position = trail_line.points.get(trail_line.points.size()-1)
	var direction = player.position - last_position
	for i in range(n):
		if (trail_line.points.size() > max_trail_time_sec * trail_points_per_second):
			if (trail_line.points.size() > 1):
				trail_collisions[0].queue_free()
				trail_collisions.remove_at(0)
			trail_line.remove_point(0)
		var new_pos :Vector2 = last_position + direction* (i+1)/n
		trail_line.add_point(new_pos)
		if (trail_line.points.size() > 1):
			var collision_segment := SegmentShape2D.new()
			collision_segment.a = trail_line.points.get(trail_line.points.size()-2)
			collision_segment.b = trail_line.points.get(trail_line.points.size()-1)
			var collision_shape := CollisionShape2D.new()
			collision_shape.shape = collision_segment
			add_child(collision_shape)
			trail_collisions.append(collision_shape)
	time_since_last_point_sec = fmod(time_since_last_point_sec, 1.0/trail_points_per_second)
	

func handle_combo(mob: Mob) -> Combo:
	for combo in combos:
		if combo.mobs.has(mob): return combo
	var combo = Combo.new()
	combo.mobs = dead_mobs.duplicate()
	combo.count = dead_mobs.size()
	if (combo.count > 1):
		var combo_indicator := combo_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(combo_indicator)
		combo_indicator.position = mob.position
	combos.append(combo)
	return combo

func handle_dead_mob():
	time_since_last_death_handle = 0.0
	var mob = dead_mobs.get(dead_mobs.size()-1)
	var combo = handle_combo(mob)
	AudioController.hit_sfx((combo.count - combo.mobs.size()) * 0.075 + 1)
	combo.mobs.remove_at(combo.mobs.rfind(mob))
	if (combo.mobs.size() == 0):
		AudioController.cheer()
		combos.remove_at(combos.rfind(combo))
	dead_mobs.remove_at(dead_mobs.size()-1)
	
	level.freeze(freeze_time)
	match mob.type:
		Mob.Type.BASIC:
			mob.animation_player.play("basic_death")
		Mob.Type.CAT:
			mob.animation_player.play("cat_death")
		Mob.Type.SLIME:
			mob.animation_player.play("slime_death")
		Mob.Type.RAMIRO:
			mob.animation_player.play("ramiro_death")

func _physics_process(delta: float) -> void:
	if (Engine.time_scale == 0): return
	if (!player.playing or !can_trail): return
	
	
	time_since_last_point_sec += delta
	time_since_last_circle_sec += delta
	time_since_last_death_handle += delta
	
	if (dead_mobs.size() > 0 and time_since_last_death_handle > time_per_death_handle_sec):
		handle_dead_mob()
	
	if (time_since_last_point_sec > 1.0/trail_points_per_second):
		add_point()
	var closest_point = find_closest_point(last_points_tolerance)
	var distance = player.position.distance_to(closest_point)
	
	if (distance < min_distance_to_oldest_points and !cleared_points 
	and time_since_last_circle_sec > circle_min_timeout_sec):
		try_spawn_circle(closest_point)
		
	if distance > min_distance_to_oldest_points * 3:
		cleared_points = false
		
