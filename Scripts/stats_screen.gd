extends Control

func _ready() -> void:
	AudioController.win_music()
	$Stat1.text = str(Stats.get_highest_combo())
	$Stat2.text = str(Stats.get_loops_drawn())
	$Stat3.text = str(Stats.get_highest_loop())
	$Stat4.text = str(Stats.get_damage_taken())
	$Stat5.text = str(int(roundf(Stats.get_total_time())))


func _on_back_pressed() -> void:
	AudioController.ui_back_sfx()
	AudioController.win_music_stop()
	AudioController.removelowpass()
	await get_tree().create_timer(0.3, true, false, true).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_back_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_back_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
