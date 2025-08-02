extends Node2D
class_name Level

@onready var player: Player = $Player

func _ready() -> void:
	AudioController.choose_tutorial_music()
	AudioController.tutorial_music()

func pause():
	$PauseMenu.visible = true
	AudioController.choose_tutorial_drums()
	AudioController.applylowpass()
	Engine.time_scale = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func unpause():
	AudioController.choose_tutorial_music()
	AudioController.removelowpass()
	$PauseMenu.visible = false
	Engine.time_scale = 1
	if player.playing: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float)  -> void:
	if Input.is_action_just_pressed("Esc") and !$PauseMenu.visible:
		call_deferred("pause")
	elif Input.is_action_just_pressed("Esc") and $PauseMenu.visible:
		call_deferred("unpause")

func freeze(duration):
	if (duration == 0): return
	Engine.time_scale = 0.05
	AudioController.tutorial_music_pause()
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	AudioController.tutorial_music_resume()
