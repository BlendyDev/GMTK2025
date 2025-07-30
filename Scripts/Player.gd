extends CharacterBody2D

@export var mouse_pos: Vector2
@export var overlapping_count: int
@onready var offset :Vector2 = (get_viewport().size/2) 
@export var last_pos : Vector2
@export var speed: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_pos = get_viewport().get_mouse_position()
	last_pos = mouse_pos
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass # Replace with function body.

func _input(e: InputEvent):
	match e.get_class():
		"InputEventMouseMotion":
			velocity = Vector2(
				min(offset.x, max(-offset.x, position.x + e.relative.x))-position.x,
				min(offset.y, max(-offset.y, position.y + e.relative.y))-position.y
			)*speed
			move_and_slide()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	mouse_pos = get_viewport().get_mouse_position()
	
	
	if (overlapping_count == 0):
		last_pos = position
	pass
