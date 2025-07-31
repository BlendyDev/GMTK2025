extends CharacterBody2D

@onready var offset :Vector2 = (get_viewport().size/2) 
@export var speed: float
@export var trail: Line2D
@export var trail_points_per_second: int
var playing := false
@onready var last_trail_point_timestamp : int = Time.get_ticks_msec()
@export var max_time_sec: float
@export var min_distance_to_oldest_points: float
var cleared_points = true
@onready var last_circle_timestamp:= Time.get_ticks_msec()
@export var circle_min_timeout_sec: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_trail_point_timestamp = Time.get_ticks_msec()
	pass # Replace with function body.

func bind_to_player():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("playing!")
	playing = true

func _input(e: InputEvent):
	match e.get_class():
		"InputEventMouseMotion":
			if !playing: return
			velocity = Vector2(
				min(offset.x, max(-offset.x, position.x + e.relative.x))-position.x,
				min(offset.y, max(-offset.y, position.y + e.relative.y))-position.y
			)*speed
			move_and_slide()

func find_closest_point(rate: float) -> Vector2:
	var point: Vector2
	var distance:float = INF
	for i in range (min(trail.points.size(), ceil(rate*max_time_sec*trail_points_per_second))):
		var current_point := trail.points.get(i)
		var current_dist := position.distance_to(current_point)
		if (current_dist < distance):
			distance = current_dist
			point = current_point
	return point


func spawn_circle(closest_point: Vector2):
	$"../finalTrail/AudioStreamPlayer2D".play()
	var fade_out_trail = Line2D.new()
	fade_out_trail.antialiased = true
	fade_out_trail.width = 3.0
	fade_out_trail.points = trail.points.duplicate()
	for i in range(trail.points.size()):
		if (fade_out_trail.points.get(0) == closest_point): break
		fade_out_trail.remove_point(0)
		
	fade_out_trail.add_point(closest_point)
	var area = Area2D.new()
	fade_out_trail.add_child(area)
	var initial_polygon :PackedVector2Array = fade_out_trail.points.duplicate()
	var polygons := simplify_polygon(initial_polygon)
	print(polygons.size())
	for polygon in polygons:
		var collision = CollisionPolygon2D.new()
		collision.polygon = polygon
		area.add_child(collision)
	
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out_trail, "default_color", Color.from_rgba8(255, 255, 255, 0), 1)
	tween.tween_callback(fade_out_trail.queue_free)
	get_tree().current_scene.add_child(fade_out_trail)
	
	
	trail.clear_points()

func simplify_polygon(polygon: PackedVector2Array) -> Array[PackedVector2Array]:
	return Geometry2D.merge_polygons(polygon, PackedVector2Array([]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
		
	if !playing:
		return
	if (Time.get_ticks_msec() - last_trail_point_timestamp > 1000.0/trail_points_per_second):
		var n = floor((Time.get_ticks_msec() - last_trail_point_timestamp) / (1000.0/trail_points_per_second))
		for i in range(n):
			if (trail.points.size() > max_time_sec * trail_points_per_second):
				trail.remove_point(0)
			trail.add_point(position)
		last_trail_point_timestamp += n* (1000.0/trail_points_per_second)
		pass
	var closest_point = find_closest_point(0.2)
	var distance = position.distance_to(closest_point)
	if (distance < min_distance_to_oldest_points and !cleared_points 
	and Time.get_ticks_msec() - last_circle_timestamp > 1000*circle_min_timeout_sec):
		last_circle_timestamp = Time.get_ticks_msec()
		spawn_circle(closest_point)
		cleared_points = true
	if distance > min_distance_to_oldest_points * 3:
		cleared_points = false
	
	
	pass


func _on_mouse_entered() -> void:
	if (!playing): bind_to_player()
	pass # Replace with function body.
