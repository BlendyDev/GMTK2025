extends Control

var played_music = false

func _ready() -> void:
	AudioController.menu_music()
	played_music = true

func _on_play_pressed() -> void:
	AudioController.ui_click_sfx()
	AudioController.menu_music_stop()
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _on_play_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_credits_pressed() -> void:
	AudioController.ui_click_sfx()

func _on_credits_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_exit_pressed() -> void:
	AudioController.ui_click_sfx()
	$HBoxContainer.visible = true
	$Sure.visible = true
	
func _on_exit_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	AudioController.ui_back_sfx()
	$HBoxContainer.visible = false
	$Sure.visible = false


func _on_options_pressed() -> void:
	AudioController.ui_click_sfx()
	var effect = AudioServer.get_bus_effect(1, 0)
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(effect, "resonance", 0.5, 0.5)
	$OptionsMenu.visible = true

func _on_options_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_yes_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_yes_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()

func _on_options_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()

func _on_quit_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()

func _on_credits_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()

func _on_play_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_no_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_no_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
