extends Node2D

@onready var texted = false
@onready var spaced = false
@onready var total = 0

func _process(delta: float) -> void:
	$TextureProgressBar.value = total
	if (Input.is_anything_pressed() and !texted):
		print("Hold space to skip cutscene (please don't if it's the first time you play!!)")
		$AnimationPlayer.play("showtext")
		texted = true
	if Input.is_action_just_pressed("Space"):
		spaced = true
	if Input.is_action_pressed("Space"):
		total += delta
		$TextureProgressBar.visible = true
		
	if Input.is_action_just_released("Space"):
		total = 0
		spaced = false
		$TextureProgressBar.visible = false

	if total > 1.5:
		total = 0
		spaced = false
		$ColorRect.visible = true
		$VideoStreamPlayer.paused = true
		pass
		
	pass
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	texted = false
	pass # Replace with function body.
