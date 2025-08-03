extends AnimationPlayer
class_name Tutorial
enum Stage {PRE, PRE_SENSITIVITY, PRE_LEFT, PRE_RIGHT, PRE_BOTH, PRE_LEMNISCATE, PRE_RESET, PRE_COMPLETED, COMPLETED}
@onready var boss: Boss = $"../Boss"
var stage: Stage
var transitioning: bool = false
var animation_data = {
	Stage.PRE: ["pre1_final"],
	Stage.PRE_SENSITIVITY: ["pre_sensitivity1", "pre_sensitivity2_final"],
	Stage.PRE_LEFT: ["pre_left1", "pre_left2", "pre_left3_final"],
	Stage.PRE_RIGHT: ["pre_right1", "pre_right2_final"],
	Stage.PRE_BOTH: ["pre_both1", "pre_both2", "pre_both3", "pre_both4_final"],
	Stage.PRE_LEMNISCATE: ["pre_lemniscate1", "pre_lemniscate2", "pre_lemniscate3", "pre_lemniscate4", "pre_lemniscate5", "pre_lemniscate6", "pre_lemniscate7", "pre_lemniscate8"],
	Stage.PRE_RESET: ["pre_reset1", "pre_reset2", "pre_reset3_final"],
	Stage.PRE_COMPLETED: ["pre_completed1_final"]
}
var comboed_dummies: Array[Dummy]


var loop:= 0

var subanimation := 0

func changed_sensitivity():
	if (stage == Stage.PRE_SENSITIVITY and !transitioning): 
		stage = Stage.PRE_LEFT

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
	comboed_dummies = []
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (stage == Stage.PRE): return
	if (comboed_dummies.size() > 1 and stage == Stage.PRE_BOTH and !transitioning):
		stage = Stage.PRE_LEMNISCATE
	if (comboed_dummies.size() > 1 and loop > 1 and stage == Stage.PRE_LEMNISCATE and !transitioning):
		stage = Stage.PRE_RESET
	if (stage == Stage.COMPLETED and boss.action == Boss.Action.PRE and !transitioning):
		boss.activate()
	comboed_dummies.clear()
	pass
