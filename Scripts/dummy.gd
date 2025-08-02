extends Area2D
class_name Dummy

var loop:= 0

enum Stage {PRE, PRE_SENSITIVITY, PRE_LEFT, PRE_RIGHT, PRE_BOTH, PRE_LEMNISCATE, PRE_RESET}

static var stage = Stage.PRE_SENSITIVITY

static func changed_sensitivity():
	if (stage == Stage.PRE_SENSITIVITY): 
		stage = Stage.PRE_LEFT

@export var id: int
@onready var trail: Trail = $"../Trail"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		
		pass
	pass # Replace with function body.
