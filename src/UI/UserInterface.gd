extends Control

onready var fade_screen = get_node("CanvasLayer/Fade/AnimationPlayer")
onready var scene_tree: = get_tree()
onready var pause_overlay = get_node("PauseOverlay")
onready var level_score = get_node("level_score")
onready var reset_label = get_node("PauseOverlay/resets_label")
onready var dashes = get_node("AbilityCounts/dashes")
onready var reflects = get_node("AbilityCounts/blocks")

var paused: = false setget set_paused


func _ready():
# warning-ignore:return_value_discarded
	PlayerData.connect("level_score_updated",self,"update_interface")
# warning-ignore:return_value_discarded
	PlayerData.connect("restart_level",self,"update_interface")
# warning-ignore:return_value_discarded
	PlayerData.connect("used_dash",self,"update_interface")
# warning-ignore:return_value_discarded
	PlayerData.connect("used_reflect",self,"update_interface")
	update_interface()
	
func set_paused (value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	if paused:
		Backgroundmusic.pause()
	else:
		Backgroundmusic.unpause()

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		restart()
	if event.is_action_pressed("pause"):
		set_paused(!paused)

func restart():
	set_paused(true)
	fade_screen.play("FadeOut")
	yield(fade_screen,"animation_finished")
	PlayerData.set_level_restarts(1)
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
func update_interface():
	level_score.text ="%s" % PlayerData.level_score
	reset_label.text = "Restarts: %s" % PlayerData.level_restarts
	dashes.text ="%s" % PlayerData.dash_uses
	reflects.text ="%s" % PlayerData.reflect_uses
