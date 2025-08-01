extends Node

func circle_sfx():
	$CircleSFX.play()
	
func fail_circle_sfx():
	$FailCircleSFX.play()

func hit_sfx():
	$HitSFX.play()

func menu_music():
	$MenuMusic.play()
func menu_music_stop():
	$MenuMusic.stop()
func menu_music_pause():
	$MenuMusic.volume_db = -80.0
	#$MenuMusic.stream_paused = true
func menu_music_resume():
	$MenuMusic.volume_db = 0
	#$MenuMusic.stream_paused = false
