extends Control
class_name SFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func circle_finish():
	$CircleFinish.play()
func circle_reset():
	$CircleReset.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
