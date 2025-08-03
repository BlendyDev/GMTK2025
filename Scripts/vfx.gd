extends Control
class_name VFX
@onready var trail_reset_player: AnimationPlayer= $TrailReset/AnimationPlayer

func trail_reset():
	trail_reset_player.play("trail_reset")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
