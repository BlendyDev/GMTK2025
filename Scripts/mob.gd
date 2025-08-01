extends CharacterBody2D
class_name Mob

@onready var player: Player = $"../Player"
@onready var trail: Trail = $"../Trail"
var bodies_entered: Array[Node2D]
@onready var timer = $SwitchAction
@onready var rng = RandomNumberGenerator.new()
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var boss: Boss = $"../Boss"

enum Action {IDLE, MOVING, DYING}
enum Type {BASIC, CAT, SLIME, RAMIRO}
var action: Action
var type: Type
var speed = 250.0

func init_basic():
	type = Type.BASIC
	animation_player.play("basic_idle")
	
func init_cat():
	type = Type.CAT
	animation_player.play("cat_idle")
	
func init_slime():
	type = Type.SLIME
	animation_player.play("slime_idle")
	
func init_ramiro():
	type = Type.RAMIRO
	animation_player.play("ramiro_idle")
	
func init_random():
	var new_type := rng.randi_range(0, 3)
	if new_type == 0: init_basic()
	elif new_type == 1: init_cat()
	elif new_type == 2: init_slime()
	else: init_ramiro()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	action = Action.IDLE
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	if (Engine.time_scale == 0): return
	var friction :Vector2= velocity*delta/timer.wait_time
	if (friction.length() > velocity.length()): velocity = Vector2.ZERO
	else: velocity -= friction
	
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	if !trail.can_trail: return
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
	pass # Replace with function body.


func _on_switch_action_timeout() -> void:
	match action:
		Action.IDLE:
			action = Action.MOVING
			var angle = rng.randf_range(0.0, 2*PI)
			velocity = (Vector2(cos(angle), sin(angle)) + (player.position-position).normalized()*2).normalized()
			velocity = velocity * speed * rng.randf_range(0.75, 1.25)
			timer.wait_time = 0.3
			timer.start()
		Action.MOVING:
			action = Action.IDLE
			velocity = Vector2.ZERO
			timer.wait_time = 0.6
			timer.start()
	pass # Replace with function body.

func _on_player_detect_area_entered(area: Area2D) -> void:
	if (area.collision_layer == pow(2, 10-1) and action != Action.DYING): #traced circle
		action = Action.DYING
		boss.mobs_alive -= 1
		trail.dead_mobs.append(self)
		pass
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name.contains("_death")):
		queue_free()
	pass # Replace with function body.
