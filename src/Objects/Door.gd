tool
extends Area2D

onready var sprite = get_node("door")
onready var scene = get_parent().get_node("UI/UserInterface")

export var next_scene : PackedScene



func _get_configuration_warning():
	return "The next scene property can't be empty" if not next_scene else ""
	
func _on_Door_body_entered(body):
	teleport(body)


func teleport(body):
	if body.is_in_group("player"):
		sprite.play("default")
		yield(sprite,"animation_finished")
		scene.fade_screen.play("FadeOut")
		PlayerData.set_score(PlayerData.level_score)
		PlayerData.set_restarts(PlayerData.get_level_restarts())
		PlayerData.new_level()
		get_tree().change_scene_to(next_scene)
	
