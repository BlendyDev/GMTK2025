extends Control

func _ready() -> void:
	AudioController.menu_music()

func _on_play_pressed() -> void:
	AudioController.menu_music_stop()
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _on_play_mouse_entered() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_credits_mouse_entered() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	$HBoxContainer.visible = true
	$Sure.visible = true
	
func _on_exit_mouse_entered() -> void:
	pass


func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	$HBoxContainer.visible = false
	$Sure.visible = false
