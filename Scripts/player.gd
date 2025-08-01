extends CharacterBody2D

class_name Player

@onready var offset :Vector2 = (get_viewport().size/2) 
@export var speed: float = 0.3
var playing := false
var mouse_motion:= Vector2.ZERO
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var last_velocities: PackedVector2Array = [Vector2.ZERO]
@export var stored_velocity_frames: int

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
			if Engine.time_scale == 0: return
			mouse_motion = e.relative
			

func animate_direction():
	if (velocity.length() > 0):
		last_velocities.append(velocity)
		if (last_velocities.size() > stored_velocity_frames):
			last_velocities.remove_at(0)
	var combined_velocity := Vector2.ZERO
	for v in last_velocities:
		combined_velocity += v.normalized()
	var offset_angle := (combined_velocity.angle_to(Vector2.RIGHT) + PI)/(2*PI) + 1.0/16.0
	if (offset_angle < 1.0/8.0):
		sprite.animation = "left"
	elif(offset_angle < 1.0/4.0):
		sprite.animation = "down_left"
	elif(offset_angle < 3.0/8.0):     
		sprite.animation = "down"
	elif(offset_angle < 1.0/2.0):
		sprite.animation = "down_right"
	elif(offset_angle < 5.0/8.0):
		sprite.animation = "right"
	elif(offset_angle < 3.0/4.0):
		sprite.animation = "up_right"
	elif(offset_angle < 7.0/8.0):
		sprite.animation = "up"
	elif(offset_angle < 1):
		sprite.animation = "up_left"
	else:
		sprite.animation = "left"
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
	if !playing:
		return
	velocity = mouse_motion*speed * (1/delta)
	animate_direction()
	mouse_motion = Vector2.ZERO
	move_and_slide()
	pass


func _on_mouse_entered() -> void:
	if (!playing): bind_to_player()
	pass # Replace with function body.
