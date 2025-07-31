extends Area2D

@onready var angle := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity := Vector2(cos(angle), sin(angle))*100
	position += velocity * delta
	angle = fmod(angle + delta*10, 2 * PI)
	pass
