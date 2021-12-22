extends Node2D

export var bulletScene: PackedScene


func fire():
	var bullet = bulletScene.instance()
	get_parent().get_parent().call_deferred("add_child",bullet)
	bullet.global_position = self.global_position
	bullet.direction.x = get_parent().direction.x
	
