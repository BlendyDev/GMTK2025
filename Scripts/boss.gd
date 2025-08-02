extends CharacterBody2D
class_name Boss

const CENTER := Vector2(0,0)
const UP_LEFT := Vector2(-197,-97)
const LEFT := Vector2(-197, 0)
const DOWN_LEFT := Vector2(-197, 97)
const DOWN := Vector2(0, 97)
const DOWN_RIGHT := Vector2(197, 97)
const RIGHT := Vector2(197, 0)
const UP_RIGHT := Vector2(197, -97)
const UP := Vector2(0, -97)

@onready var effect = AudioServer.get_bus_effect(1, 0)
@onready var player: Player = $"../Player"
@onready var trail: Trail = $"../Trail"
var bodies_entered: Array[Node2D]
@onready var timer = $SwitchAction
@onready var rng = RandomNumberGenerator.new()
@onready var animation_player := $AnimationPlayer
@onready var debug_text: RichTextLabel = $"../DebugText"

enum Action {PRE, IDLE, MOVING, SPAWNING, SHIELD, SHIELD_MOVING, DYING}
@export var action: Action
var hp = 26
var shield = 0
@onready var snapped_pos = CENTER
@onready var trail_curve = preload("res://Templates/boss_trail_curve.tres")
@onready var mob_scene = preload("res://Scenes/mob.tscn")
var spawned_mobs = 0
var mobs_alive = 0
var line_tween: Tween
var pos_tween: Tween
var available_locations := [UP_LEFT, LEFT, DOWN_LEFT, DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT, UP]
@export var dash_speed := 300.0
@export var spawn_shield_speed := 100.0

func _ready() -> void:
	action = Action.PRE
	timer.start()
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (Engine.time_scale == 0): return
	debug_text.text ="lowpass resonance: " + str(effect.resonance) + "\naction: " + Action.keys()[action] + "\nspawned_mobs: " + str(spawned_mobs) + "\nmobs_alive: " + str(mobs_alive) + "\nhp: " + str(hp) + "\nshield: " + str(shield)
	if (action == Action.SHIELD and mobs_alive == 0):
		start_spawning()

func start_spawning():
	action = Action.SPAWNING
	trail_to_random_pos(spawn_shield_speed)
	animation_player.play("spawning")
	spawned_mobs = 0

func is_shielding()-> bool: return action == Action.SHIELD or action == Action.SHIELD_MOVING

func activate():
	animation_player.play("dashing")
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
		AudioController.fail_circle_sfx()
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	var index := bodies_entered.rfind(body)
	if (index != -1): bodies_entered.remove_at(index)
	if (bodies_entered.is_empty()): trail.can_trail = true
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
		
func move(index: int, move_speed: float = dash_speed):
	var new_pos = available_locations.get(index)
	available_locations.remove_at(index)
	available_locations.append(snapped_pos)
	snapped_pos = new_pos
	trail_to_move(snapped_pos, move_speed)

func trail_to_move(pos: Vector2, move_speed: float = dash_speed):
	if (pos_tween):
		pos_tween.kill()
	var line = Line2D.new()
	line.width = 15
	line.default_color = Color.from_rgba8(128, 64, 133, 255)
	line.width_curve = trail_curve
	line.add_point(Vector2.ZERO)
	line.add_point(pos-position)
	get_tree().current_scene.add_child(line)
	line.position = position
	line_tween = get_tree().create_tween()
	line_tween.set_ease(Tween.EASE_IN)
	line_tween.set_trans(Tween.TRANS_CUBIC)
	line_tween.tween_property(line, "width", 0, 0.75)
	line_tween.tween_callback(line.queue_free)
	line_tween.tween_callback(execute_move.bind(pos, move_speed))
	

func execute_move(pos: Vector2, move_speed: float = dash_speed):
	pos_tween = get_tree().create_tween()
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.set_trans(Tween.TRANS_QUINT)
	pos_tween.tween_property(self, "position", pos, pos.distance_to(position) / move_speed)
	pos_tween.tween_callback(finish_move)

func move_to(loc: Vector2):
	if (snapped_pos == loc): return
	var index := available_locations.rfind(loc)
	if (index == -1): return
	move(index)

func pick_location_and_move():
	var index := rng.randi_range(0, available_locations.size()-1)
	move(index)
	

func finish_move():
	if (action != Action.MOVING):
		if (action == Action.SHIELD):
			trail_to_move(UP_LEFT)
			action = Action.SHIELD_MOVING
		elif (action == Action.SHIELD_MOVING):
			if (mobs_alive == 0): start_spawning()
			else: action = Action.SHIELD
		elif (action == Action.SPAWNING):
			if (spawned_mobs < 3):
				trail_to_random_pos(spawn_shield_speed)
				spawn_mob()
				mobs_alive += 1
				timer.wait_time = 1.5
				timer.start()
			else:
				if (mobs_alive > 0):
					spawned_mobs = 0
					action = Action.SHIELD_MOVING
					animation_player.play("shielding")
					trail_to_move(UP_LEFT, spawn_shield_speed)
				else:
					start_spawning()
		return
	action = Action.IDLE
	timer.wait_time = 1.0
	timer.start()

func _on_switch_action_timeout() -> void:
	if (action == Action.IDLE):
		action = Action.MOVING
		animation_player.play("dashing")
		pick_location_and_move()

func spawn_mob():
	spawned_mobs += 1
	var mob : Mob= mob_scene.instantiate()
	mob.position = position
	mob.scale = Vector2.ZERO
	get_tree().current_scene.call_deferred("add_child", mob)
	mob.call_deferred("init_random")
	pass

func trail_to_random_pos(move_speed: float = dash_speed):
	var x := rng.randf_range(LEFT.x, RIGHT.x)
	var y := rng.randf_range(DOWN.y, UP.y)
	trail_to_move(Vector2(x, y), move_speed)

func _on_player_detect_area_entered(area: Area2D) -> void:
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		if (action == Action.MOVING or action == Action.IDLE):
			AudioController.cat_hit_sfx()
			hp -= 1
			if (hp%5 == 0):
				if (action == Action.IDLE):
					trail_to_random_pos(spawn_shield_speed)
					timer.wait_time = 1.5
					timer.start()
				animation_player.play("spawning")
				action = Action.SPAWNING
				spawned_mobs = 0
				timer.wait_time = 0.8
				timer.start()
				
