extends Node2D


func play_music():
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.pitch_scale = 1

func pause():
	$AudioStreamPlayer.pitch_scale = 0.1
	
func unpause():
	$AudioStreamPlayer.pitch_scale = 1

func death():
	$AudioStreamPlayer.pitch_scale = 0.6
