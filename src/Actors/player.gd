extends KinematicBody2D

export var MAX_SPEED = 300
export var ACCELERATION = 1200
export var JUMP_FORCE = 350
export var GRAVITY_FORCE = 600
export var COYOTE_TIMER = 0.1
export var JUMP_BUFFER = 0.1
export var WALL_JUMP = Vector2(500,350)

const FLOOR_NORMAL: = Vector2.UP
const dash_speed = 1000
const dash_duration=0.2

onready var dash = get_node("dash")
onready var sprite = get_node("player")
onready var anim = get_node("AnimationPlayer")
onready var right_wall = get_node("RightWall")
onready var left_wall = get_node("LeftWall")
onready var blade = get_node("blade/CollisionShape2D")
onready var reflect = get_node("Reflect")
onready var audio_player = get_node("AudioStreamPlayer2D")

var _velocity = Vector2(0,0)
var direction = Vector2(0,0)
var canCoyoteJump = true
var jumpWasPressed = false
var isAttacking = false
var inAir = false
var player_look = 1
var isDead = false


func _ready():
	blade.disabled = true


func _physics_process(delta):
	if !isDead:
		movement_loop(delta)

# warning-ignore:unused_argument
func _process(delta):
	if !isDead:
		animation_loop()



# warning-ignore:unused_argument
func _input(event):
	if !isDead:
		if Input.is_action_just_pressed("reflect") and !isAttacking and !inAir and reflect.uses > 0:
			player_reflect()
		if Input.is_action_just_pressed("attack"):
			audio_player.stream = load("res://src/Sounds/blade.wav")
			audio_player.play()
			isAttacking = true
			anim.play("attack")
			yield(anim,"animation_finished")
			isAttacking = false
		if Input.is_action_just_pressed("jump") and !reflect.is_reflecting:
			jumpWasPressed = true
			
			jumpBuffer()
			if canCoyoteJump:
				_velocity.y = -JUMP_FORCE
				canCoyoteJump = false
			if not is_on_floor() and nextToLeftWall():
				_velocity.y -= WALL_JUMP.y
				_velocity.x += WALL_JUMP.x
				
			if not is_on_floor() and nextToRightWall():
				_velocity.y -= WALL_JUMP.y
				_velocity.x -= WALL_JUMP.x
		if Input.is_action_just_pressed("left"):
			if player_look != -1:
				_flip()
				player_look = -1
		if Input.is_action_just_pressed("right"):
			if player_look != 1:
				_flip()
				player_look = 1
		if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing() and dash.uses > 0:
			dash.start_dash(sprite,dash_duration)
			

func movement_loop(delta):
	if is_on_floor():
		if inAir == true:
			inAir = false
			_velocity.y = 0.1
			sprite.flip_h = false
		canCoyoteJump = true
		if jumpWasPressed:
			_velocity.y = -JUMP_FORCE
		



	if !is_on_floor():
		inAir = true
		coyoteTime()
		_velocity.y += GRAVITY_FORCE * delta
		if nextToWall():
			anim.play("wall_slide")
			if nextToRightWall():
				
				sprite.flip_h = true
			if nextToLeftWall():
				sprite.flip_h = false
					
			if _velocity.y > 70:
				_velocity.y = 70
		
		
# warning-ignore:incompatible_ternary
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") if !reflect.is_reflecting else 0 

	if direction.x== 0 and !is_dashing():
		_velocity.x = 0
		
	elif !dash.is_dashing():
		_velocity.x += ACCELERATION * delta * direction.x
		if direction.x < 0:
			if _velocity.x < -MAX_SPEED:
				_velocity.x = -MAX_SPEED
		if direction.x > 0:
			if _velocity.x > MAX_SPEED:
				_velocity.x = MAX_SPEED
	elif dash.is_dashing():
		_velocity.x = dash_speed * player_look
		

	
# warning-ignore:return_value_discarded
	move_and_slide(_velocity,FLOOR_NORMAL)



func coyoteTime():
	yield(get_tree().create_timer(COYOTE_TIMER),"timeout")
	canCoyoteJump = false

func jumpBuffer():
	yield(get_tree().create_timer(JUMP_BUFFER),"timeout")
	jumpWasPressed = false

func animation_loop():
	if !isAttacking and is_on_floor() and !reflect.is_reflecting:
		if _velocity.x !=0 and !nextToWall():
			anim.play("run")
		elif _velocity.x == 0  and !nextToWall():
			anim.play("idle")
	if !is_on_floor() and !nextToWall() and !isAttacking:
		
		anim.play("inair")



func _on_blade_body_entered(body):
	if body.is_in_group('enemy'):
		body._hit()


func nextToWall():
	return nextToRightWall() or nextToLeftWall()
	
func nextToRightWall():
	return right_wall.is_colliding()
	
func nextToLeftWall():
	return left_wall.is_colliding()

func _flip():
	scale.x *= -1

func _hit():
	if dash.is_dashing():
		return
	isDead = true
	audio_player.stream = load("res://src/Sounds/player_death.wav")
	audio_player.play()
	anim.play("die")
	Backgroundmusic.death()
	
	
func is_dashing():
	return dash.is_dashing()

func player_reflect():
	reflect.start_reflect()
	anim.play("reflect")
	


func _on_Camera2D_ready():
	$Camera2D.current = true
	
