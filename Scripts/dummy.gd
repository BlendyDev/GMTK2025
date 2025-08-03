extends Area2D
class_name Dummy


@export var id: int
@onready var trail: Trail = $"../Trail"
@onready var boss: Boss = $"../Boss"
@onready var vfx: VFX = $"../VFX"
@onready var tutorial_animations:AnimationPlayer = $"../TutorialAnimations"
@onready var tutorial: Tutorial = $"../TutorialAnimations"

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
		vfx.trail_reset()
		AudioController.fail_circle_sfx()

func _on_body_exited(body: Node2D) -> void:
	var index := trail.bodies_entered.rfind(body)
	if (index != -1): trail.bodies_entered.remove_at(index)
	if (trail.bodies_entered.is_empty()): trail.can_trail = true

func _on_area_entered(area: Area2D) -> void:
	pass
	if (area.collision_layer == pow(2, 10-1)): #traced circle
		tutorial.comboed_dummies.append(self)
		if (tutorial.stage == Tutorial.Stage.PRE_LEFT and !tutorial.transitioning): 
			tutorial.stage = Tutorial.Stage.PRE_RIGHT
			tutorial.start_segment()
		if (tutorial.stage == Tutorial.Stage.PRE_RIGHT and !tutorial.transitioning): 
			tutorial.stage = Tutorial.Stage.PRE_BOTH
			tutorial.start_segment()
		pass
