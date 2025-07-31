extends StaticBody2D
class_name Trail

@export var trail: Line2D
@export var trail_points_per_second: int
@onready var last_trail_point_timestamp : int = Time.get_ticks_msec()
@export var max_time_sec: float
@export var min_distance_to_oldest_points: float
var cleared_points = true
@onready var last_circle_timestamp:= Time.get_ticks_msec()
@export var circle_min_timeout_sec: float
@export var player: Player
var trail_collisions: Array[CollisionShape2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_trail_point_timestamp = Time.get_ticks_msec()
	pass # Replace with function body.

func find_closest_point(rate: float) -> Vector2:
	var point: Vector2
	var distance:float = INF
	for i in range (min(trail.points.size(), ceil(rate*max_time_sec*trail_points_per_second))):
		var current_point := trail.points.get(i)
		var current_dist := player.position.distance_to(current_point)
		if (current_dist < distance):
			distance = current_dist
			point = current_point
	return point

func simplify_polygon(polygon: PackedVector2Array) -> Array[PackedVector2Array]:
	return Geometry2D.merge_polygons(polygon, PackedVector2Array([]))

func reset_trail():
	last_circle_timestamp = Time.get_ticks_msec()
	for collision_shape in trail_collisions:
		collision_shape.queue_free()
	trail_collisions.clear()
	trail.clear_points()

func spawn_circle(closest_point: Vector2):
	$"../Trail/AudioStreamPlayer2D".play()
	var fade_out_trail = Line2D.new()
	fade_out_trail.antialiased = true
	fade_out_trail.width = 3.0
	fade_out_trail.points = trail.points.duplicate()
	for i in range(trail.points.size()):
		if (fade_out_trail.points.get(0) == closest_point): break
		fade_out_trail.remove_point(0)
		
	fade_out_trail.add_point(closest_point)
	var area = Area2D.new()
	area.collision_layer = pow(2, 10-1)
	area.collision_mask = pow(2, 3-1)
	fade_out_trail.add_child(area)
	var initial_polygon :PackedVector2Array = fade_out_trail.points.duplicate()
	var polygons := simplify_polygon(initial_polygon)
	for polygon in polygons:
		var collision = CollisionPolygon2D.new()
		collision.polygon = polygon
		area.add_child(collision)
	
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out_trail, "default_color", Color.from_rgba8(255, 255, 255, 0), 1)
	tween.tween_callback(fade_out_trail.queue_free)
	get_tree().current_scene.add_child(fade_out_trail)
	
	reset_trail()

func _physics_process(delta: float) -> void:
	if (Time.get_ticks_msec() - last_trail_point_timestamp > 1000.0/trail_points_per_second):
		var n = floor((Time.get_ticks_msec() - last_trail_point_timestamp) / (1000.0/trail_points_per_second))
		var points: Array[Vector2]
		var last_position: Vector2
		if (trail.points.size() == 0): last_position = player.position
		else: last_position = trail.points.get(trail.points.size()-1)
		var direction = player.position - last_position
		for i in range(n):
			if (trail.points.size() > max_time_sec * trail_points_per_second):
				if (trail.points.size() > 1):
					trail_collisions[0].queue_free()
					trail_collisions.remove_at(0)
				trail.remove_point(0)
			var new_pos :Vector2 = last_position + direction* (i+1)/n
			trail.add_point(new_pos)
			if (trail.points.size() > 1):
				var collision_segment := SegmentShape2D.new()
				collision_segment.a = trail.points.get(trail.points.size()-2)
				collision_segment.b = trail.points.get(trail.points.size()-1)
				var collision_shape := CollisionShape2D.new()
				collision_shape.shape = collision_segment
				add_child(collision_shape)
				trail_collisions.append(collision_shape)
		last_trail_point_timestamp += n* (1000.0/trail_points_per_second)
	
		if (Input.is_key_pressed(KEY_SPACE)):
			pass
		pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!player.playing): return
	if (trail.points.size() > 1):
		pass
	
	var closest_point = find_closest_point(0.2)
	var distance = player.position.distance_to(closest_point)
	
	if (distance < min_distance_to_oldest_points and !cleared_points 
	and Time.get_ticks_msec() - last_circle_timestamp > 1000*circle_min_timeout_sec):
		
		spawn_circle(closest_point)
		cleared_points = true
	if distance > min_distance_to_oldest_points * 3:
		cleared_points = false
	pass
