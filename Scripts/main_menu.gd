extends Control

@export var tween_intensity : float
@export var tween_duration : float
@onready var play : TextureButton = $Play
@onready var exit : TextureButton = $Quit

var played_music = false

func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func _ready() -> void:
	AudioController.level_music_stop()
	AudioController.removelowpass()
	AudioController.makeclickloudagain()
	AudioController.menu_music()
	played_music = true
	AudioController.removelowpass()
	$Play/AnimationPlayer.play("idle")
	$Credits/AnimationPlayer.play("idle")
	$Options/AnimationPlayer.play("idle")
	if (Stats.best_damage_taken == -1):
		$Trophy/AnimationPlayer.play("blocked")
	else:
		$Trophy/AnimationPlayer.play("normal")



func _on_play_pressed() -> void:
	$Play/GoofySFX.stop()
	$Quit/LightSFX.stop()
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
	AudioController.hey_sfx()

func _on_credits_pressed() -> void:
	$Credits/CreditsMenu.play()
	AudioController.applylowpass()
	$CreditsScene.visible = true
	AudioController.ui_click_sfx()
	start_tween($CreditsScene, "modulate", Color(1.0, 1.0, 1.0), 0.5 )

func _on_credits_mouse_entered() -> void:
	$Credits/AnimationPlayer.play("credits")
	AudioController.ui_hover_sfx()
	AudioController.swoosh_sfx()

func _on_exit_pressed() -> void:
	AudioController.ui_click_sfx()
	$VBoxContainer.visible = true
	$YesBG.visible = true
	$NoBG.visible = true
	$AnimationPlayer.play("movetext")
	
func _on_exit_mouse_entered() -> void:
	AudioController.ui_hover_sfx()
	$Quit/AnimationPlayer.play("lightflicker")
	if !$Quit/LightSFX.playing:
		$Quit/LightSFX.play()


func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	AudioController.ui_back_sfx()
	$VBoxContainer.visible = false
	$YesBG.visible = false
	$NoBG.visible = false
	$AnimationPlayer.stop()


func _on_options_pressed() -> void:
	AudioController.waterstream_sfx()
	AudioController.ui_click_sfx()
	AudioController.applylowpass()
	$OptionsMenu.visible = true

func _on_options_mouse_entered() -> void:
	start_tween($Options, "rotation", PI/2.0, tween_duration)
	$Options.pivot_offset = $Options.size / 2
	$Options/AnimationPlayer.play("hover")
	AudioController.ui_hover_sfx()
	AudioController.swoosh_sfx()

func _on_yes_mouse_entered() -> void:
	AudioController.ui_hover_sfx()

func _on_yes_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()

func _on_options_mouse_exited() -> void:
	$Options.pivot_offset = $Options.size / 2
	start_tween($Options, "rotation", 0, tween_duration)
	AudioController.ui_lookaway_sfx()
	$Options/AnimationPlayer.play("idle")

func _on_quit_mouse_exited() -> void:
	$Quit/LightSFX.playing = false
	AudioController.ui_lookaway_sfx()
	$Quit/AnimationPlayer.play("idle")

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


func _on_back_pressed() -> void:
	start_tween($CreditsScene, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	$CreditsScene.visible = false
	AudioController.ui_back_sfx()
	AudioController.removelowpass()
	$Credits/CreditsMenu.stop()


func _on_back_mouse_entered() -> void:
	AudioController.ui_hover_sfx()


func _on_back_mouse_exited() -> void:
	AudioController.ui_lookaway_sfx()


func _on_trophy_pressed() -> void:
	if (Stats.best_damage_taken == -1):
		AudioController.hit_cancel_sfx()
		return
	AudioController.menu_music_stop()
	AudioController.ui_click_sfx()
	get_tree().change_scene_to_file("res://Scenes/stats_screen.tscn")


func _on_trophy_mouse_entered() -> void:
	if (Stats.best_damage_taken != -1):
		$Trophy/AnimationPlayer.play("shine")
	AudioController.ui_hover_sfx()
	$Trophy/TrophySFX.play()


func _on_trophy_mouse_exited() -> void:
	if (Stats.best_damage_taken != -1):
		$Trophy/AnimationPlayer.play("normal")
	AudioController.ui_lookaway_sfx()
