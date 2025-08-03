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

enum Action {PRE, APPEAR, IDLE, MOVING, SPAWNING, SHIELD, SHIELD_MOVING, PRE_DYING, DYING}

@onready var player: Player = $"../Player"
@onready var trail: Trail = $"../Trail"
@onready var debug_text: RichTextLabel = $"../DebugText"
@onready var timer = $SwitchAction
@onready var animation_player :AnimationPlayer= $AnimationPlayer

@onready var effect = AudioServer.get_bus_effect(1, 0)
@onready var rng = RandomNumberGenerator.new()

@onready var snapped_pos = CENTER

@onready var trail_curve = preload("res://Templates/boss_trail_curve.tres")
@onready var mob_scene = preload("res://Scenes/mob.tscn")
@onready var boss_death_scene = preload("res://Scenes/boss_death.tscn")

@export var action: Action
@export var shield_threshold: int
@export var dash_speed := 500.0
@export var spawn_shield_speed := 200.0
@export var max_hp := 30

var available_locations := [UP_LEFT, LEFT, DOWN_LEFT, DOWN, DOWN_RIGHT, RIGHT, UP_RIGHT, UP]


var hp := max_hp
var shield := 0
var spawned_mobs := 0
var mobs_alive := 0
var queued_deaths := 0
var line_tween: Tween
var pos_tween: Tween

func _ready() -> void:
	action = Action.PRE
	timer.start()
	pass # Replace with function body.

func _process(delta: float) -> void:
	if get_tree().paused: return
	debug_text.text = "highest combo: " + str(Stats.get_highest_combo()) + "\nloops drawn: " + str(Stats.get_loops_drawn()) + "\nhighest loop: " + str(Stats.get_highest_loop()) + "\ndamage taken: " + str(Stats.get_damage_taken()) + "\ntotal time: " + str(Stats.get_total_time()) + "\nshield threshold: " + str(shield_threshold) + "\nanimation: " + str(animation_player.current_animation) + "\ntutorial stage" + str(Dummy.Stage.keys()[Dummy.stage]) + "\nfps: " + str(Engine.get_frames_per_second()) + "\nsensitivity boost: " + str(Global.sensitivity_boost) + "\ncircle cooldown: " + str(max(0, trail.circle_min_timeout_sec - trail.time_since_last_circle_sec)) + "\ncleared points: " + str(trail.cleared_points) + "\nloop count: " + str(trail.loop_count) + "\nlowpass resonance: " + str(effect.resonance) + "\naction: " + Action.keys()[action] + "\nspawned_mobs: " + str(spawned_mobs) + "\nmobs_alive: " + str(mobs_alive) + "\nhp: " + str(hp) + "\nshield: " + str(shield)
	
	if (action == Action.SHIELD and mobs_alive == 0):
		if (shield < shield_threshold): start_spawning()
		else:
			shield = 0
			hp -= 1
			action = Action.MOVING
			animation_player.play("dashing")
			pick_location_and_move()

func max_spawns()->int:
	return 8-hp/5 

func calculate_shield_threshold():
	return -4 * hp + 150

func start_spawning():
	action = Action.SPAWNING
	trail_to_random_pos(spawn_shield_speed)
	animation_player.play("spawning")
	spawned_mobs = 0

func is_shielding()-> bool: return action == Action.SHIELD or action == Action.SHIELD_MOVING

func activate():
	if (action != Action.PRE): return
	#Engine.time_scale = .1
	visible = true
	action = Action.APPEAR
	animation_player.queue("appear")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "appear" and action == Action.APPEAR):
		action = Action.IDLE
		animation_player.play("dashing")
		timer.wait_time = 1.0
		timer.start()
	if (anim_name == "death" and action == Action.DYING):
		var boss_death: Node2D = boss_death_scene.instantiate()
		boss_death.position = position
		get_tree().current_scene.add_child(boss_death)
		visible = false
		

func _on_body_entered(body: Node2D) -> void:
	if !trail.can_trail: return
	if action == Action.PRE: return
	if action == Action.DYING or action == Action.PRE_DYING: return
	if body is Player or body is Trail:
		if !trail.bodies_entered.has(body): trail.bodies_entered.append(body)
		trail.can_trail = false
		trail.animate_fail_trail()
		trail.reset_trail()
		Stats.damage_taken += 1
		AudioController.fail_circle_sfx()
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	var index := trail.bodies_entered.rfind(body)
	if (index != -1): trail.bodies_entered.remove_at(index)
	if (trail.bodies_entered.is_empty()): trail.can_trail = true

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
	AudioController.preteleport_sfx()

func execute_move(pos: Vector2, move_speed: float = dash_speed):
	pos_tween = get_tree().create_tween()
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.set_trans(Tween.TRANS_QUINT)
	pos_tween.tween_property(self, "position", pos, pos.distance_to(position) / move_speed)
	pos_tween.tween_callback(finish_move)
	AudioController.teleport_sfx()

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
			if (mobs_alive == 0):
				if (shield < shield_threshold):
					start_spawning()
				else:
					shield = 0
					hp -= 1
					action = Action.MOVING
					animation_player.play("dashing")
					pick_location_and_move()
			else: action = Action.SHIELD
		elif (action == Action.SPAWNING):
			if (spawned_mobs < max_spawns()):
				trail_to_random_pos(spawn_shield_speed)
				spawn_mob()
				mobs_alive += 1
			else:
				if (mobs_alive > 0):
					spawned_mobs = 0
					action = Action.SHIELD_MOVING
					animation_player.play("shielding")
					trail_to_move(UP_LEFT, spawn_shield_speed)
				else:
					if (shield < shield_threshold):
						start_spawning()
					else:
						shield = 0
						hp -= 1
						action = Action.MOVING
						animation_player.play("dashing")
						pick_location_and_move()
		elif (action == Action.PRE_DYING):
			action = Action.DYING
			animation_player.play("death")
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
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		if (action == Action.MOVING or action == Action.IDLE):
			AudioController.cat_hit_sfx()
			hp -= 1
			if (hp <= 0):
				action = Action.PRE_DYING
				trail_to_move(CENTER)
			elif (hp%5 == 0):
				if (action == Action.IDLE):
					trail_to_random_pos(spawn_shield_speed)
					timer.wait_time = 1.5
					timer.start()
				animation_player.play("spawning")
				action = Action.SPAWNING
				shield = 0
				shield_threshold = calculate_shield_threshold()
				spawned_mobs = 0
				timer.wait_time = 0.8
				timer.start()
			else:
				if (timer.wait_time > 0.1):
					timer.start(0.1)


func _on_animation_player_current_animation_changed(name: String) -> void:
	pass # Replace with function body.
