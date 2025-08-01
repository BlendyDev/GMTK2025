extends Node

func circle_sfx():
	$CircleSFX.play()
	
func fail_circle_sfx():
	$FailCircleSFX.play()

func hit_sfx():
	$HitSFX.play()
	
func ui_click_sfx():
	$UIClickSFX.play()
	
func ui_hover_sfx():
	$UIHoverSFX.play()

func ui_back_sfx():
	$UIBackSFX.play()

func ui_lookaway_sfx():
	$UILookawaySFX.play()

func ui_sliderclick_sfx():
	$UISliderClickSFX.play()
func ui_sliderendclick_sfx():
	$UISliderClickEndSFX.play()


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
