extends KinematicBody2D

onready var sprite = get_node("enemy")
onready var anim = get_node("AnimationPlayer")
onready var flash_timer = get_node("flash_timer")
onready var hitbox = get_node("Hitbox")
onready var hurtbox = get_node("Hurtbox/CollisionShape2D")
onready var movetimer = get_node("movement_timer")
onready var shottimer = get_node("shot_timer")
onready var sightline = get_node("SightLine")
onready var gun = get_node("Gun")
onready var audio_player = get_node("AudioStreamPlayer2D")
onready var reaction = get_node("Timer")
onready var attack_cooldown = get_node("attack_cooldown")


const FLOOR_NORMAL: = Vector2.UP
export var SPEED = 25


var _velocity = Vector2(0,0.2)
var direction = Vector2(1,0)
var can_move = false
var isdead = false
var can_shoot = false
var isAttacking = false


func _ready():
	hitbox.disabled = false
	hurtbox.disabled = false
	movetimer.start()

func _physics_process(delta):
	if !isdead and !isAttacking:
		movement_loop(delta)


# warning-ignore:unused_argument
func _process(delta):
	if !isdead and !isAttacking:
		animation_loop()
	
	if isAttacking and !isdead:
		movetimer.stop()
		attack()



func animation_loop():
	if can_move and !isAttacking:
		anim.play("walk")
		
	if isAttacking:
		pass
	
	if !can_move and !isAttacking:
		anim.play("idle")

# warning-ignore:unused_argument
func movement_loop(delta):
	if can_move == false:
		_velocity.x = 0
	if can_move and !isAttacking:
		_velocity.x = SPEED * direction.x
		_velocity.y = 0.1
# warning-ignore:unused_variable
		var _collison = move_and_slide(_velocity,FLOOR_NORMAL)
			

func _hit():
	audio_player.stream = load("res://src/Sounds/enemy_death.wav")
	audio_player.play()
	movetimer.stop()
	isdead = true
	can_move = false
	isAttacking = false
	shottimer.stop()
	flash()
	movetimer.stop()
	anim.play("die")
	yield(anim,"animation_finished")

func flash():
	sprite.material.set_shader_param("flash_modifier",1)
	flash_timer.start()

func _on_flash_timer_timeout():
	sprite.material.set_shader_param("flash_modifier",0)


func _on_Hurtbox_body_entered(body):
	if body.is_in_group('player'):
		body._hit()
	


func _on_SightLine_body_entered(body):
	if body.is_in_group('player'):
		if body.is_dashing():
			$Timer.start()
			yield($Timer, "timeout")
		if attack_cooldown.time_left > 0:
			attack_cooldown.stop()
			isAttacking = true
			return
		isAttacking = true
		anim.play("aim")
		yield(anim,"animation_finished")

func attack():
	if shottimer.time_left == 0:
		shottimer.start()
	
		

func _on_MovementTimer_timeout():
	can_move = !can_move
	if can_move and !isAttacking:
		direction.x *= -1
		scale.x *=-1
		

func shoot():
	audio_player.stream = load("res://src/Sounds/shot.wav")
	audio_player.play()
	gun.fire()

func _on_shot_timer_timeout():
	
	anim.play("shoot")


func _on_SightLine_body_exited(body):
	if body.is_in_group("player"):
		attack_cooldown.start()
		
	


func _on_attack_cooldown_timeout():
	if !isdead:
		isAttacking = false
		movetimer.start()
