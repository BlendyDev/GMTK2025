extends Control

var played_music = false

func _ready() -> void:
	AudioController.makeclickloudagain()
	AudioController.menu_music()
	played_music = true
	AudioController.removelowpass()
	$Play/AnimationPlayer.play("idle")
	$Credits/AnimationPlayer.play("idle")



func _on_play_pressed() -> void:
	AudioController.ui_click_sfx()
	AudioController.menu_music_stop()
	$Loading2.visible = true
	await get_tree().create_timer(0.4, true, false, true).timeout
	AudioController.arpeggio_sfx()
	await get_tree().create_timer(0.4, true, false, true).timeout
	$Loading2.visible = false
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _on_play_mouse_entered() -> void:
	$Play/AnimationPlayer.play("hover")
	AudioController.ui_hover_sfx()

func _on_credits_pressed() -> void:
	AudioController.ui_click_sfx()

func _on_credits_mouse_entered() -> void:
	$Credits/AnimationPlayer.play("credits")
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
	AudioController.applylowpass()
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
	$Credits/AnimationPlayer.play("idle")

func _on_play_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
	$Play/AnimationPlayer.play("idle")


func _on_no_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_no_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
