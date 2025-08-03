extends Node

var highest_combo: int = 0
var loops_drawn: int = 0
var highest_loop: int = 0
var damage_taken: int = 0
var start_time: int

var best_highest_combo: int = 0
var best_loops_drawn: int = 0
var best_highest_loop: int = 0
var best_damage_taken: int = -1
var best_time: int = -1

var won_once : bool = false

func set_best_stats():
	if (highest_combo > best_highest_combo): best_highest_combo = highest_combo
	if (loops_drawn > best_loops_drawn): best_loops_drawn = loops_drawn
	if (highest_loop > best_highest_loop): best_highest_loop = highest_loop
	if (damage_taken < best_damage_taken or best_damage_taken == -1): best_damage_taken = damage_taken
	var current_time = get_total_time()
	if (current_time < best_time or best_time == -1): best_time = current_time
	pass

func reset_stats():
	highest_combo = 0
	loops_drawn = 0
	highest_loop = 0
	damage_taken = 0

func get_won_once():
	return won_once

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
