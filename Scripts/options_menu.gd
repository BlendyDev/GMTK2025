extends Control


func _ready() -> void:
	#effect.set_band_cutoff_hz(2000)
	#AudioEffectBandPassFilter.
	pass
	
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("Space"):
		#AudioController.circle_sfx()
	pass


func _on_back_pressed() -> void:
	AudioController.waterstreamstop_sfx()
	AudioController.ui_back_sfx()
	if get_tree().current_scene.name == "Level":
		self.visible = false
		pass
	else:
		self.visible = false
		AudioController.removelowpass()


func _on_back_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_back_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
