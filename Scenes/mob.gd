extends Area2D
class_name Mob

@onready var angle := 0.0
@export var player: Player
@export var trail: Trail

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
	if body is Player or body is Trail:
		print("resetting trail")
		trail.reset_trail()
	pass # Replace with function body.
