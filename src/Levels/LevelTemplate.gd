extends Node2D

onready var ui = get_node("UI/UserInterface")
onready var fade_screen = get_node("UI/UserInterface/CanvasLayer/Fade/AnimationPlayer")
onready var audio = get_node("AudioStreamPlayer")
onready var player = get_node("Player")

export var dash_uses = 2
export var reflect_uses = 2

func _ready():
	Backgroundmusic.play_music()
	player.dash.uses = dash_uses
	player.reflect.uses = reflect_uses
	PlayerData.set_dash(dash_uses)
	PlayerData.set_reflect(reflect_uses)
	audio.stream = load("res://src/Sounds/restart.wav")
	audio.play()
	fade_screen.play("FadeIn")
	yield(fade_screen,"animation_finished")
	PlayerData.restart_level()
	ui.set_paused(false)
	
	
