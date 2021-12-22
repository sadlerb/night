extends Node2D

var uses = 0
var can_dash = true
var dash_delay = 0.4
var dash_number = 50
var ghost = preload("res://src/Abilities/DashGhost.tscn")
onready var duration_timer = get_node("DurationTimer")
onready var ghost_timer = get_node("GhostTimer")
onready var audio = get_node("AudioStreamPlayer2D")
var player_sprite

func start_dash(sprite,duration):
	if uses > 0:
		audio.stream = load("res://src/Sounds/dash.wav")
		audio.play()
		player_sprite = sprite
		duration_timer.wait_time = duration
		duration_timer.start()
		player_sprite.material.set_shader_param("flash_modifier",0.5)
		ghost_timer.start()
		instance_ghost()
		uses -= 1
		PlayerData.use_dash()
	elif uses == 0:
		print("cant use")
	
func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	player_sprite.material.set_shader_param("flash_modifier",0)
	ghost_timer.stop()
	can_dash = false
	yield(get_tree().create_timer(dash_delay),"timeout")
	can_dash = true
	


func _on_DurationTimer_timeout():
	end_dash()

func instance_ghost():
	var instanced_ghost = ghost.instance()
	get_parent().get_parent().add_child(instanced_ghost)
	
	instanced_ghost.global_position = global_position
	instanced_ghost.texture = player_sprite.texture
	instanced_ghost.vframes = player_sprite.vframes
	instanced_ghost.hframes = player_sprite.hframes
	instanced_ghost.frame = player_sprite.frame
	instanced_ghost.scale.x= player_sprite.scale.x


func _on_GhostTimer_timeout():
	instance_ghost()
