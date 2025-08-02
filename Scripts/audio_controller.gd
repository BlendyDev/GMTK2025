extends Node

var effect = AudioServer.get_bus_effect(1, 0)
var tween : Tween
	
@onready var hitSFX: AudioStreamPlayer2D = $HitSFX
@onready var cheerSFX: AudioStreamPlayer2D = $CheerSFX

func circle_sfx():
	$CircleSFX.play()
	
func fail_circle_sfx():
	$FailCircleSFX.play()

func hit_sfx(pitch: float):
	hitSFX.pitch_scale = pitch
	hitSFX.play()
	
func cheer_sfx(count: int):
	cheerSFX.volume_linear = min(float(count+1)/4.0, 2.5)
	cheerSFX.play()

func swoosh_sfx():
	$SwooshSFX.play()
func hey_sfx():
	$HeySFX.play()

func cat_hit_sfx():
	$CatHitSFX.play()	

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

func arpeggio_sfx():
	$ArpeggioSFX.play()
	
func cut_tail_sfx():
	
	if $CutTailSFX.get_playback_position() > 0.25 or !$CutTailSFX.playing:
		$CutTailSFX.play()

func tapestop1():
	$TapeStopSFX.play()
func tapestop2():
	$TapeStop2SFX.play()
	
func spawn_slime():
	$SlimeSpawnSFX.play()
func spawn_cat():
	$CatSpawnSFX.play()
func spawn_ramiro():
	$RamiroSpawnSFX.play()
func spawn_normal():
	$NormalSpawnSFX.play()
	
func combo_sfx():
	$ComboSFX.play()
func loop_sfx():
	$LoopSFX.play()

func teleport_sfx():
	$TeleportSFX.play()
func preteleport_sfx():
	$PreTeleportSFX.play()
	
func menu_music():
	$MenuMusic.play()
func menu_music_stop():
	$MenuMusic.stop()
func tutorial_music():
	$TutorialMusic.play()
	$TutorialDrums.play()
func tutorial_music_stop():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_ignore_time_scale(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($TutorialMusic, "volume_db", -80, 0.25)
	tween.tween_property($TutorialDrums, "volume_db", -80, 0.25)
	if $TutorialMusic.volume_db == -80 && $TutorialDrums.volume_db == -80:
		$TutorialMusic.stop()
		$TutorialDrums.stop()
func tutorial_music_pause():
	$TutorialMusic.volume_db = -80.0
func tutorial_music_resume():
	$TutorialMusic.volume_db = 0
func choose_tutorial_drums():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($TutorialMusic, "volume_db", -80, 0.25)
	tween.tween_property($TutorialDrums, "volume_db", 8, 0.25)
	$TutorialMusic.volume_db = -80.0
func choose_tutorial_music():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($TutorialMusic, "volume_db", 0, 0.05)
	tween.tween_property($TutorialDrums, "volume_db", -80, 0.05)
	
func cutscene():
	$Cutscene.play()
func cutscene_stop():
	await get_tree().create_timer(1.2, true, false, true).timeout
	$UIClickSFX.volume_db = -15.0
	AudioController.ui_click_sfx()
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_ignore_time_scale(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Cutscene, "volume_db", -80, 1)
	if $Cutscene.volume_db == -80:
		$Cutscene.stop()
	
func makeclickloudagain():
	$UIClickSFX.volume_db = -1.5
	
func removelowpass():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_ignore_time_scale(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(effect, "resonance", 0, 0.25)

func applylowpass():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_ignore_time_scale(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(effect, "resonance", 0.75, 0.5)
