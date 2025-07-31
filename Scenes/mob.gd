extends Area2D
class_name Mob

@onready var angle := 0.0
@export var player: Player
@export var trail: Trail
var bodies_entered: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var velocity := Vector2(cos(angle), sin(angle))*100
	position += velocity * delta
	angle = fmod(angle + delta*10, 2 * PI)
	pass


func _on_body_entered(body: Node2D) -> void:
	if !trail.can_trail: return
	if body is Player or body is Trail:
		if !bodies_entered.has(body): bodies_entered.append(body)
		trail.can_trail = false
		trail.reset_trail()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	var index := bodies_entered.rfind(body)
	if (index != -1): bodies_entered.remove_at(index)
	if (bodies_entered.is_empty()): trail.can_trail = true
	if (Input.is_key_pressed(KEY_SPACE)):
		pass
	pass # Replace with function body.
