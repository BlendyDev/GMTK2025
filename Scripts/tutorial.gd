extends AnimationPlayer
class_name Tutorial
enum Stage {PRE, PRE_SENSITIVITY, PRE_LEFT, PRE_RIGHT, PRE_BOTH, PRE_LEMNISCATE, PRE_RESET, PRE_COMPLETED, COMPLETED}
@onready var boss: Boss = $"../Boss"
@onready var left_dummy: Node2D = $"../LeftDummy"
@onready var right_dummy: Node2D = $"../RightDummy"
@onready var text: RichTextLabel = $"../RichTextLabel"
@onready var tutorial_bg = $"../TutoBG"

var stage: Stage
var transitioning: bool = false
var animation_data = {
	Stage.PRE: ["pre1_final"],
	Stage.PRE_SENSITIVITY: ["pre_sensitivity1", "pre_sensitivity2_final"],
	Stage.PRE_LEFT: ["pre_left1", "pre_left2", "pre_left3_final"],
	Stage.PRE_RIGHT: ["pre_right1", "pre_right2_final"],
	Stage.PRE_BOTH: ["pre_both1", "pre_both2", "pre_both3", "pre_both4" , "pre_both5_final"],
	Stage.PRE_LEMNISCATE: ["pre_lemniscate1", "pre_lemniscate2", "pre_lemniscate3", "pre_lemniscate4", "pre_lemniscate5", "pre_lemniscate6", "pre_lemniscate7", "pre_lemniscate8_final"],
	Stage.PRE_RESET: ["pre_reset1", "pre_reset2", "pre_reset3_final"],
	Stage.PRE_COMPLETED: ["pre_completed1_final"]
}
var lines = {
	Stage.PRE: ["MOVE THY MOUSE TOWARDS THE MOUSE"],
	Stage.PRE_SENSITIVITY: ["INCEPTION", "ADJUST YOUR MOUSE SENSITIVITY WITH THE MOUSE WHEEL"],
	Stage.PRE_LEFT: ["GREETINGS YOUNG MOUSE
I SEE THOU HAS ACHIEVED INCREDIBLE POWER!", "ALTHOUGH THY ENEMY HAS AS WELL
PRACTICE ON THESE DUMMIES", "DRAW A CIRCLE AROUND THE FIRST ONE"],
	Stage.PRE_RIGHT: ["STELLAR!", "NOW THE RIGHT ONE"],
	Stage.PRE_BOTH: ["SIMPLY MARVELOUS!", "THIS IS THY MEANS TO ATTACK THY ENEMIES", "THE MORE ENEMIES THOU CAN FIT IN A SINGLE CIRCLE
THE HIGHER THE COMBO WILL BE", "AND THE MORE DAMAGE THOU WILL DO TO THAT CATS SHIELD" , "TRY IT OUT ON BOTH THESE DUMMIES"],
	Stage.PRE_LEMNISCATE: ["SPLENDID!", "BUT THATS NOT ALL!", "THERES ONLY ONE THING MORE SATISFYING THAN DRAWING A CIRCLE", "AND THATS DRAWING AN INFINITY SYMBOL", "A LEMNISCATE!", "A LOOP IF THOU WILL!", "THOU DO EVEN HIGHER DAMAGE IF THOU DO A LOOP INSTEAD OF A SINGLE CIRCLE", "THOU DO EVEN HIGHER DAMAGE IF THOU DO A LOOP INSTEAD OF A SINGLE CIRCLE"],
	Stage.PRE_RESET: ["EXHILARATING RIGHT?", "YOURE ALMOST READY
JUST ONE THING", "YOURE ALMOST READY
JUST ONE THING"],
	Stage.PRE_COMPLETED: ["ALWAYS TRY TO GET A HIGHER COMBO AND DONT FORGET ABOUT THE LOOPS!"]
}
var comboed_dummies: Array[Dummy]


var loop:= 0

var subanimation := 0

func changed_sensitivity():
	if (stage == Stage.PRE_SENSITIVITY and !transitioning): 
		stage = Stage.PRE_LEFT
		start_segment()

func reset_trail():
	if (stage == Stage.PRE_RESET and !transitioning):
		stage = Stage.PRE_COMPLETED
		start_segment()

func start_segment():
	subanimation = 0
	play(animation_data.get(stage)[subanimation])
	transitioning = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage = Stage.PRE
	start_segment()
	comboed_dummies = []
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("Space")):
		speed_scale = 5.0
	else:
		speed_scale = 0.6
		
	if (stage == Stage.PRE): return
	if (comboed_dummies.size() > 1 and stage == Stage.PRE_BOTH and !transitioning):
		stage = Stage.PRE_LEMNISCATE
		start_segment()
	if (comboed_dummies.size() > 1 and loop > 1 and stage == Stage.PRE_LEMNISCATE and !transitioning):
		stage = Stage.PRE_RESET
		start_segment()
	if (stage == Stage.COMPLETED and boss.action == Boss.Action.PRE and !transitioning):
		boss.activate()
	comboed_dummies.clear()
	pass

func finish_tutorial():

	AudioController.tutorial_music_stop()
	AudioController.level_music()
	var tween = get_tree().create_tween()
	tween.tween_property(tutorial_bg, "modulate", Color.from_rgba8(255, 255, 255, 0), 1)

	boss.activate()
	left_dummy.queue_free()
	right_dummy.queue_free()
	pass

func _on_animation_finished(anim_name: StringName) -> void:
	if (anim_name.contains("_final")):
		transitioning = false
		if (stage == Stage.PRE_COMPLETED):
			stage = Stage.COMPLETED
			var tween = get_tree().create_tween()
			tween.tween_property(text, "modulate", Color.from_rgba8(255, 255, 255, 0), 1.0)
			tween.tween_property(left_dummy, "modulate", Color.from_rgba8(255, 255, 255, 0), 1.0)
			tween.tween_property(right_dummy, "modulate", Color.from_rgba8(255, 255, 255, 0), 1.0)
			tween.tween_callback(finish_tutorial)
	else:
		var delay = 0.05 * lines.get(stage)[subanimation].length()
		subanimation += 1
		if (Input.is_action_pressed("Space")): delay = min( 0.5, delay/4.0)
		await get_tree().create_timer(delay, true, false, true).timeout
		play(animation_data.get(stage)[subanimation])
	pass # Replace with function body.
