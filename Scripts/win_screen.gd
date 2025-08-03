extends Control

func _ready() -> void:
	$Loading.visible = false

func _on_main_menu_pressed() -> void:
	AudioController.ui_back_sfx()
	AudioController.win_music_stop()
	$Loading.visible = true
	await get_tree().create_timer(0.4, true, false, true).timeout
	AudioController.ui_click_sfx()
	await get_tree().create_timer(0.4, true, false, true).timeout
	$Loading.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_main_menu_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_main_menu_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_quit_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
