extends Area2D

onready var anim = get_node("AnimationPlayer")
onready var box = get_node("CollisionShape2D")

func _on_Scroll_body_entered(body):
	if body.is_in_group("player"):
		PlayerData.set_level_score(1)
		anim.play("pickup")

