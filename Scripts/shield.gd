extends Sprite2D
class_name Shield

@onready var boss: Boss = $"../Boss"
@onready var line: Line2D = $Line2D
@onready var player: Player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line.points[1].x = 2 + float(max(0,boss.shield_threshold- boss.shield))/float(boss.shield_threshold) * 60
	visible = boss.hp % 5 == 0 and boss.hp < 30 and boss.hp > 0
	if (position.distance_to(player.position) < 80):
		modulate = Color.from_rgba8(255,255,255,80)
	else:
		modulate = Color.from_rgba8(255,255,255,255)
