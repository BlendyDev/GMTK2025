extends Sprite2D
class_name HP

@onready var boss: Boss = $"../Boss"
@onready var line: Line2D = $Line2D
@onready var player: Player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line.points[1].x = 2 + boss.hp * 3
	if (position.distance_to(player.position) < 80):
		modulate = Color.from_rgba8(255,255,255,80)
	else:
		modulate = Color.from_rgba8(255,255,255,255)
