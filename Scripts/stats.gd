extends Node

var highest_combo: int = 0
var loops_drawn: int = 0
var highest_loop: int = 0
var damage_taken: int = 0
var start_time: int

func get_highest_combo():
	return highest_combo
	
func get_loops_drawn():
	return loops_drawn

func get_highest_loop():
	return highest_loop

func get_damage_taken():
	return damage_taken
	
func get_total_time() -> float:
	return float(Time.get_ticks_msec() - start_time)/1000.0
