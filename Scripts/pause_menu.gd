extends Control
@onready var level : Level = $".."

func _on_resume_pressed() -> void:
	level.unpause()
func _on_resume_mouse_entered() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	$OptionsMenu.visible = true

func _on_options_mouse_entered() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	$VBoxContainer/HBoxContainer.visible = true
	$VBoxContainer/Sure.visible = true
	$VBoxContainer/HBoxContainer2.visible = false
	$VBoxContainer/Sure2.visible = false

func _on_quit_mouse_entered() -> void:
	pass # Replace with function body.


func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/Sure.visible = false


func _on_main_menu_pressed() -> void:
	$VBoxContainer/HBoxContainer2.visible = true
	$VBoxContainer/Sure2.visible = true
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/Sure.visible = false

func _on_main_menu_mouse_entered() -> void:
	pass # Replace with function body.


func _on_yes_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_no_2_pressed() -> void:
	$VBoxContainer/HBoxContainer2.visible = false
	$VBoxContainer/Sure2.visible = false
