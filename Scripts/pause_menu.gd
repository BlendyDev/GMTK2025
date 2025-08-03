extends Control
@onready var level : Level = $".."

func _ready() -> void:
	$AnimationPlayer.play("movetext")
	$Loading.visible = false
	await get_tree().create_timer(0.8, true, false, true).timeout

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc") and self.visible:
		level.unpause()
	$LabelOutline.pivot_offset.x = 0.0
	$LabelOutline.pivot_offset.y = 0.0
	#$LabelOutline.size.x = $VBoxContainer.size.x + 5
	$LabelOutline.position.x = $VBoxContainer.position.x
	#$LabelOutline.size.y = $VBoxContainer.size.y + 5
	$LabelOutline.position.y = $VBoxContainer.position.y
	

func _on_resume_pressed() -> void:
	AudioController.ui_click_sfx()
	level.unpause()
func _on_resume_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_options_pressed() -> void:
	AudioController.ui_click_sfx()
	$OptionsMenu.visible = true
	AudioController.waterstream_sfx()

func _on_options_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_quit_pressed() -> void:
	AudioController.ui_click_sfx()
	$VBoxContainer/HBoxContainer.visible = true
	$VBoxContainer/Sure.visible = true
	$VBoxContainer/HBoxContainer2.visible = false
	$VBoxContainer/Sure2.visible = false
	$YesBG2.visible = true
	$NoBG2.visible = true
	$YesBG.visible = false
	$NoBG.visible = false

func _on_quit_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	AudioController.ui_back_sfx()
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/Sure.visible = false
	$YesBG2.visible = false
	$NoBG2.visible = false


func _on_main_menu_pressed() -> void:
	AudioController.ui_click_sfx()
	$VBoxContainer/HBoxContainer2.visible = true
	$VBoxContainer/Sure2.visible = true
	$VBoxContainer/HBoxContainer.visible = false
	$VBoxContainer/Sure.visible = false
	$YesBG.visible = true
	$NoBG.visible = true
	$YesBG2.visible = false
	$NoBG2.visible = false

func _on_main_menu_mouse_entered() -> void:
	AudioController.ui_hover_sfx()
	pass # Replace with function body.


func _on_yes_2_pressed() -> void:
	$YesBG.visible = false
	$NoBG.visible = false
	AudioController.ui_back_sfx()
	AudioController.tutorial_music_stop()
	$Loading.visible = true
	await get_tree().create_timer(0.4, true, false, true).timeout
	AudioController.ui_click_sfx()
	await get_tree().create_timer(0.4, true, false, true).timeout
	$Loading.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_no_2_pressed() -> void:
	AudioController.ui_back_sfx()
	$VBoxContainer/HBoxContainer2.visible = false
	$VBoxContainer/Sure2.visible = false
	$YesBG.visible = false
	$NoBG.visible = false


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
