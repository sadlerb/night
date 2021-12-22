extends KinematicBody2D

export var speed = 250
var direction = Vector2.ZERO
export var smokeScene: PackedScene
export var bulletImpact: PackedScene

func _process(delta):
	var collision_result = move_and_collide(direction * speed * delta)
	if collision_result != null:
		var smoke = smokeScene.instance() as Particles2D
		
		if collision_result.collider.has_method('_hit'):
			collision_result.collider._hit()
		get_parent().add_child(smoke)
		smoke.global_position = collision_result.position
		smoke.rotation = collision_result.normal.angle()
		
		var impact = bulletImpact.instance() as Node2D
		
		get_parent().add_child(impact)
		impact.global_position = collision_result.position
		impact.rotation = collision_result.normal.angle()
		
		call_deferred("queue_free")


func reverse():
	direction.x *= -1

func block():
	direction.x *= -1
	direction.y = rand_range(-2,2)
	rotation = direction.angle()
