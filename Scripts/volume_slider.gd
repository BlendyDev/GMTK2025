extends HSlider

@export var bus_name: String

var bus_index: int
@onready var bg: Control = $BG

func adjust_size():
	bg.size = Vector2(27.0 + value*(152.0-27.0), bg.size.y)

func _ready() -> void:
	adjust_size()
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _on_value_changed(value: float) -> void:
	adjust_size()
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_drag_started() -> void:
	AudioController.ui_sliderclick_sfx()


func _on_drag_ended(value_changed: bool) -> void:
	AudioController.ui_sliderendclick_sfx()
