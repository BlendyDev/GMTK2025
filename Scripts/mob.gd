extends CharacterBody2D
class_name Mob

@onready var player: Player = $"../Player"
@onready var trail: Trail = $"../Trail"
@onready var sfx: SFX = $"../SFX"
var bodies_entered: Array[Node2D]
@onready var timer = $SwitchAction
@onready var rng = RandomNumberGenerator.new()
@onready var sprite = $Sprite2D

enum Action {IDLE, MOVING, DYING}
enum Type {BASIC, CAT, SLIME, RAMIRO}
var action: Action
var type: Type
var speed = 250.0

func init_basic():
	type = Type.BASIC
	$AnimationPlayer.play("basic_idle")
	
func init_cat():
	type = Type.CAT
	$AnimationPlayer.play("cat_idle")
	
func init_slime():
	type = Type.SLIME
	$AnimationPlayer.play("slime_idle")
	
func init_ramiro():
	type = Type.BASIC
	$AnimationPlayer.play("ramiro_idle")
	
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
		sfx.circle_reset()
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
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		action = Action.DYING
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "scale", Vector2.ZERO, 0.7)
		tween.tween_callback(queue_free)
		pass
	pass # Replace with function body.
