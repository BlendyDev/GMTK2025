extends Node2D
class_name Level

func pause():
	$PauseMenu.visible = true
	Engine.time_scale = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func unpause():
	$PauseMenu.visible = false
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc") and !$PauseMenu.visible:
		call_deferred("pause")
	elif Input.is_action_just_pressed("Esc") and $PauseMenu.visible:
		call_deferred("unpause")
