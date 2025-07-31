extends CharacterBody2D

class_name Player

@onready var offset :Vector2 = (get_viewport().size/2) 
@export var speed: float
var playing := false
var mouse_motion:= Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func bind_to_player():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("playing!")
	playing = true

func _input(e: InputEvent):
	match e.get_class():
		"InputEventMouseMotion":
			if !playing: return
			mouse_motion = e.relative
			
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(
		min(offset.x, max(-offset.x, position.x + mouse_motion.x))-position.x,
		min(offset.y, max(-offset.y, position.y + mouse_motion.y))-position.y
	)*speed * (1/delta)
	mouse_motion = Vector2.ZERO
	print(velocity)
	print(delta)
	move_and_slide()
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
		
	if !playing:
		return
	pass


func _on_mouse_entered() -> void:
	if (!playing): bind_to_player()
	pass # Replace with function body.
