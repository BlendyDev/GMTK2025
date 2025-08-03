extends Node2D

var tween : Tween

@onready var loading: AnimatedSprite2D = $"../Loading"
@onready var colorrect: ColorRect = $"../ColorRect"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "death"):
		#game end
		Stats.set_best_stats()
		#AudioController.stop_level_music()
		tween = get_tree().create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
		tween.set_ignore_time_scale(true)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(colorrect, "color", Color(0.0, 0.0, 0.0), 1)
		await get_tree().create_timer(1, true, false, true).timeout
		loading.visible = true
		await get_tree().create_timer(0.4, true, false, true).timeout
		await get_tree().create_timer(0.4, true, false, true).timeout
		get_tree().paused = false
		loading.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
