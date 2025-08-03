extends RichTextLabel

@onready var boss: Boss = $"../Boss"
@onready var trail: Trail = $"../Trail"
@onready var tutorial: Tutorial = $"../TutorialAnimations"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Debug")):
		visible = !visible
	text = "highest combo: " + str(Stats.get_highest_combo()) + "\nloops drawn: " + str(Stats.get_loops_drawn()) + "\nhighest loop: " + str(Stats.get_highest_loop()) + "\ndamage taken: " + str(Stats.get_damage_taken()) + "\ntotal time: " + str(Stats.get_total_time()) + "\nshield threshold: " + str(boss.shield_threshold) + "\nanimation: " + str(boss.animation_player.current_animation) + "\ntutorial stage" + str(Tutorial.Stage.keys()[tutorial.stage]) + "\nfps: " + str(Engine.get_frames_per_second()) + "\nsensitivity boost: " + str(Global.sensitivity_boost) + "\ncircle cooldown: " + str(max(0, trail.circle_min_timeout_sec - trail.time_since_last_circle_sec)) + "\ncleared points: " + str(trail.cleared_points) + "\nloop count: " + str(trail.loop_count) + "\naction: " + Boss.Action.keys()[boss.action] + "\nspawned_mobs: " + str(boss.spawned_mobs) + "\nmobs_alive: " + str(boss.mobs_alive) + "\nhp: " + str(boss.hp) + "\nshield: " + str(boss.shield)
	pass
