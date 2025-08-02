extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = (Global.sensitivity_boost*4.0-1.0)/11.0
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_value_changed(value: float) -> void:
	Global.sensitivity_boost = (11.0*value + 1.0)/4.0
