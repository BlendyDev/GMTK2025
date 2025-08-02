extends Area2D
class_name Dummy

var loop:= 0

enum Stage {PRE, PRE_SENSITIVITY, PRE_LEFT, PRE_RIGHT, PRE_BOTH, PRE_LEMNISCATE, PRE_RESET, COMPLETED}

static var stage
static var comboed_dummies: Array[Dummy]

static func changed_sensitivity():
	if (stage == Stage.PRE_SENSITIVITY): 
		stage = Stage.PRE_LEFT

@export var id: int
@onready var trail: Trail = $"../Trail"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage = Stage.PRE
	comboed_dummies = []
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (stage == Stage.PRE or stage == Stage.COMPLETED): return
	if (comboed_dummies.size() > 1 and stage == Stage.PRE_BOTH):
		stage = Stage.PRE_LEMNISCATE
	comboed_dummies.clear()
	pass

func _on_body_entered(body: Node2D) -> void:
	if !trail.can_trail: return
	if body is Player or body is Trail:
		if !trail.bodies_entered.has(body): trail.bodies_entered.append(body)
		trail.can_trail = false
		trail.animate_fail_trail()
		trail.reset_trail()
		AudioController.fail_circle_sfx()

func _on_body_exited(body: Node2D) -> void:
	var index := trail.bodies_entered.rfind(body)
	if (index != -1): trail.bodies_entered.remove_at(index)
	if (trail.bodies_entered.is_empty()): trail.can_trail = true

func _on_area_entered(area: Area2D) -> void:
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		print("id: " + str(id) + "|stage: " + str(Stage.keys()[stage]))
		comboed_dummies.append(self)
		if (id == 0 and stage == Stage.PRE_LEFT): 
			stage = Stage.PRE_RIGHT
		if (id == 1 and stage == Stage.PRE_RIGHT): 
			stage = Stage.PRE_BOTH
		pass
	pass # Replace with function body.
