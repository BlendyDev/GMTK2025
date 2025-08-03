extends HSlider
@onready var bg: Control = $BG


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_size()
	value = (Global.sensitivity_boost*4.0-1.0)/11.0
	pass # Replace with function body.

func adjust_size():
	bg.size = Vector2(22 + value*(310-22.0), bg.size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_value_changed(value: float) -> void:
	adjust_size()
	Global.sensitivity_boost = (11.0*value + 1.0)/4.0
