extends Node2D

@onready var texted = false
@onready var spaced = false
@onready var total = 0

@export var bus_name: String

var bus_index: int
var switching := false

func _ready() -> void:
	AudioController.cutscene()
	bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(1, linear_to_db(0.75))

func _process(delta: float) -> void:
	$TextureProgressBar.value = total
	if (Input.is_anything_pressed() and !texted):
		$AnimationPlayer.play("showtext")
		texted = true
	if Input.is_action_pressed("Space"):
		total += delta
		$TextureProgressBar.visible = true
	if Input.is_action_just_released("Space"):
		total = 0
		spaced = false
		$TextureProgressBar.visible = false
	if total > 1.5 and switching == false:
		switching = true
		AudioController.cut_tail_sfx()
		spaced = false
		AudioController.cutscene_stop()
		$AnimationPlayer.play("switch_scene")
	
	if Input.is_action_pressed("Up"):
		$AnimationPlayer.speed_scale = 4.0
	else:
		$AnimationPlayer.speed_scale = 1.0
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "showtext":
		texted = false
	else:
		$VideoStreamPlayer.paused = true
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
