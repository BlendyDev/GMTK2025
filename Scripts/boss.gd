extends CharacterBody2D

const CENTER := Vector2(0,0)
const UP_LEFT := Vector2(-197,-97)
const LEFT := Vector2(-197, 0)
const DOWN_LEFT := Vector2(-197, 97)
const DOWN := Vector2(0, 97)
const DOWN_RIGHT := Vector2(197, 97)
const RIGHT := Vector2(197, 0)
const UP_RIGHT := Vector2(197, -97)
const UP := Vector2(0, -97)

@export var player: Player
@export var trail: Trail
@export var sfx: SFX
var bodies_entered: Array[Node2D]
@onready var timer = $SwitchAction
@onready var rng = RandomNumberGenerator.new()
@onready var sprite = $Sprite2D

enum Action {PRE, IDLE, MOVING, SHIELD, DYING}
@export var action: Action
var speed = 250.0
var hp = 30
@onready var snapped_pos = CENTER
@onready var trail_sprite = preload("res://Sprites/trail.png")

var available_locations := [UP_LEFT, LEFT, DOWN_LEFT, DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT, UP]

func _ready() -> void:
	action = Action.PRE
	timer.start()
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (action == Action.SHIELD): modulate = Color.from_rgba8(255, 0, 0, 255)
	else: modulate = Color.from_rgba8(255, 255, 255, 255)

func activate():
	action = Action.IDLE
	timer.wait_time = 1.0
	timer.start()

func _on_body_entered(body: Node2D) -> void:
	if !trail.can_trail: return
	if action == Action.PRE: return
	if action == Action.DYING: return
	if body is Player or body is Trail:
		if !bodies_entered.has(body): bodies_entered.append(body)
		trail.can_trail = false
		trail.animate_fail_trail()
		trail.reset_trail()
		sfx.circle_reset()
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	var index := bodies_entered.rfind(body)
	if (index != -1): bodies_entered.remove_at(index)
	if (bodies_entered.is_empty()): trail.can_trail = true
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
		
func move(index: int):
	var new_pos = available_locations.get(index)
	available_locations.remove_at(index)
	available_locations.append(snapped_pos)
	snapped_pos = new_pos
	var line = Line2D.new()
	line.width = 6
	line.texture = trail_sprite
	line.add_point(Vector2.ZERO)
	line.add_point(snapped_pos-position)
	add_child(line)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	#tween.tween_property(line, "modulate", Color.from_rgba8(255, 255, 255, 0), 0.5)
	tween.tween_property(self, "position", snapped_pos, 0.5)
	tween.tween_callback(line.queue_free)
	tween.tween_callback(finish_move)

func move_to(loc: Vector2):
	if (snapped_pos == loc): return
	var index := available_locations.rfind(loc)
	if (index == -1): return
	move(index)

func pick_location_and_move():
	var index := rng.randi_range(0, 7)
	move(index)
	

func finish_move():
	if (action != Action.MOVING):
		if (action == Action.SHIELD): move_to(UP_LEFT)
		return
	action = Action.IDLE
	timer.wait_time = 1.0
	timer.start()

func _on_switch_action_timeout() -> void:
	if (action == Action.IDLE):
		action = Action.MOVING
		pick_location_and_move()

func _on_player_detect_area_entered(area: Area2D) -> void:
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		if (action == Action.MOVING or action == Action.IDLE):
			hp -= 1
			if (hp%5 == 0):
				if (action == Action.IDLE):
					move_to(UP_LEFT)
				action = Action.SHIELD
