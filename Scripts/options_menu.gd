extends Control

@onready var effect:AudioEffectBandPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)

func _ready() -> void:
	#effect.set_band_cutoff_hz(2000)
	#AudioEffectBandPassFilter.
	pass
	
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("Space"):
		#AudioController.circle_sfx()
	pass

func _on_sensitivity_slider_value_changed(value: float) -> void:
	pass # Replace with function body.

func _on_back_pressed() -> void:
	AudioController.ui_back_sfx()
	if get_tree().current_scene.name == "Level":
		self.visible = false
		effect.resonance = 0
		pass
	else:
		#effect.set_band_cutoff_hz(15000)
		self.visible = false
		var tween := get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(effect, "resonance", 0, 0.25)


func _on_back_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_back_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
