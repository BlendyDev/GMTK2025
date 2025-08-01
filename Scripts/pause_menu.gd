extends Control
@onready var level : Level = $".."

func _on_resume_pressed() -> void:
	AudioController.ui_click_sfx()
	level.unpause()
func _on_resume_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_options_pressed() -> void:
	AudioController.ui_click_sfx()
	$OptionsMenu.visible = true

func _on_options_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_quit_pressed() -> void:
	AudioController.ui_click_sfx()
	$VBoxContainer/HBoxContainer.visible = true
	$VBoxContainer/Sure.visible = true
	$VBoxContainer/HBoxContainer2.visible = false
	$VBoxContainer/Sure2.visible = false

func _on_quit_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	AudioController.ui_back_sfx()
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/Sure.visible = false


func _on_main_menu_pressed() -> void:
	AudioController.ui_click_sfx()
	$VBoxContainer/HBoxContainer2.visible = true
	$VBoxContainer/Sure2.visible = true
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/Sure.visible = false

func _on_main_menu_mouse_entered() -> void:
	AudioController.ui_hover_sfx()
	pass # Replace with function body.


func _on_yes_2_pressed() -> void:
	AudioController.ui_back_sfx()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_no_2_pressed() -> void:
	AudioController.ui_back_sfx()
	$VBoxContainer/HBoxContainer2.visible = false
	$VBoxContainer/Sure2.visible = false


func _on_yes_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_yes_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_no_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_no_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_yes_2_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_yes_2_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_resume_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_options_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_main_menu_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_quit_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_no_2_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_no_2_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()
