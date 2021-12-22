extends Node2D


onready var reflect_timer = get_node("ReflectTimer")
onready var perfect_reflect_timer = get_node("PerfectReflect")
onready var reflect_area = get_node("Area2D/ReflectArea")
onready var audio = get_node("AudioStreamPlayer2D")

var is_reflecting = false
var uses = 0

func start_reflect():
	if uses > 0:
		perfect_reflect_timer.start()
		reflect_timer.start()
		reflect_area.disabled = false
		is_reflecting = true
		uses -= 1 
		PlayerData.use_reflect()
	elif uses == 0:
		pass


func end_reflect():
	reflect_area.disabled = true
	is_reflecting = false
	
	


func _on_ReflectTimer_timeout():
	end_reflect()


func _on_body_entered(body):
	if body.is_in_group("bullet"):
		if perfect_reflect_timer.time_left > 0:
			body.reverse()
			audio.stream = load("res://src/Sounds/reflect.wav")
			audio.play()
		else:
			audio.stream = load("res://src/Sounds/block.wav")
			audio.play()
			body.block()
