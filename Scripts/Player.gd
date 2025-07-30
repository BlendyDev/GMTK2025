extends CharacterBody2D

@onready var offset :Vector2 = (get_viewport().size/2) 
@export var speed: float
@export var trail: Line2D
@export var trail_points_per_second: int
var playing := false
@onready var last_trail_point_timestamp : int = Time.get_ticks_msec()
@export var max_time_sec: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_trail_point_timestamp = Time.get_ticks_msec()
	pass # Replace with function body.

func bind_to_player():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Time.get_ticks_msec() - last_trail_point_timestamp > 1000/trail_points_per_second):
		var n = floor((Time.get_ticks_msec() - last_trail_point_timestamp) / (1000/trail_points_per_second))
		for i in range(n):
			if (trail.points.size() > max_time_sec * trail_points_per_second):
				trail.remove_point(0)
			trail.add_point(position)
		last_trail_point_timestamp += n* (1000/trail_points_per_second)
		pass
	
	if ((get_viewport().get_mouse_position()-offset).distance_to(position) < 30 and !playing):
		bind_to_player()
	pass
