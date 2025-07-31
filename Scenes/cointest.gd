extends StaticBody2D


func _on_mouse_entered() -> void:
	print("mamañema")
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("particles")
	pass # Replace with function body.
