extends Area2D
class_name Dummy

enum Stage {PRE, PRE_SENSITIVITY, PRE_LEFT, PRE_RIGHT, PRE_BOTH, PRE_LEMNISCATE, PRE_RESET, COMPLETED}

static var stage: Stage
static var transitioning: bool
static var comboed_dummies: Array[Dummy]

@export var id: int
@onready var trail: Trail = $"../Trail"
@onready var boss: Boss = $"../Boss"
@onready var vfx: VFX = $"../VFX"

var loop:= 0

static func changed_sensitivity():
	if (stage == Stage.PRE_SENSITIVITY): 
		stage = Stage.PRE_LEFT

static func reset_trail():
	if (stage == Stage.PRE_RESET):
		stage = Stage.COMPLETED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage = Stage.PRE_RESET
	comboed_dummies = []
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (stage == Stage.PRE): return
	if (id != 0): return # make leftmost dummy handle processing
	if (comboed_dummies.size() > 1 and stage == Stage.PRE_BOTH):
		stage = Stage.PRE_LEMNISCATE
	if (comboed_dummies.size() > 1 and loop > 1 and stage == Stage.PRE_LEMNISCATE):
		stage = Stage.PRE_RESET
	if (stage == Stage.COMPLETED and boss.action == Boss.Action.PRE):
		boss.activate()
	comboed_dummies.clear()
	
	pass

func _on_body_entered(body: Node2D) -> void:
	if !trail.can_trail: return
	if body is Player or body is Trail:
		if !trail.bodies_entered.has(body): trail.bodies_entered.append(body)
		trail.can_trail = false
		trail.animate_fail_trail()
		trail.reset_trail()
		vfx.trail_reset()
		AudioController.fail_circle_sfx()

func _on_body_exited(body: Node2D) -> void:
	var index := trail.bodies_entered.rfind(body)
	if (index != -1): trail.bodies_entered.remove_at(index)
	if (trail.bodies_entered.is_empty()): trail.can_trail = true

func _on_area_entered(area: Area2D) -> void:
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		comboed_dummies.append(self)
		if (id == 0 and stage == Stage.PRE_LEFT): 
			stage = Stage.PRE_RIGHT
		if (id == 1 and stage == Stage.PRE_RIGHT): 
			stage = Stage.PRE_BOTH
		pass
