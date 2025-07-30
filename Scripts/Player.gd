extends CharacterBody2D

@onready var offset :Vector2 = (get_viewport().size/2) 
@export var last_pos : Vector2
@export var speed: float
var playing := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if ((get_viewport().get_mouse_position()-offset).distance_to(position) < 30 and !playing):
		bind_to_player()
	pass
