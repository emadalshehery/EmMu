extends CharacterBody2D

class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash : GPUParticles2D = $DashParticles

var speed = 150.0
var gravity = 1000

#jump
var JumpPower = -400.0
var JumpsMade = 0

#dash
var DashSpeed = 500
var Dash = false
var CanDash = true

func _physics_process(delta):
	
	if Input.is_action_pressed("camera_down"):
		$Camera2D.position.y = -150
	elif Input.is_action_pressed("camera_up"):
		$Camera2D.position.y = 100
	elif Input.is_action_pressed("camera_left"):
		$Camera2D.position.x = -100
	elif Input.is_action_pressed("camera_right"):
		$Camera2D.position.x = 100
	else:
		$Camera2D.position.x = 0
		$Camera2D.position.y = -22
	
	#gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else :
		JumpsMade = 0

	#get the direction
	var direction = Input.get_axis("move_left", "move_right")
	
	# jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JumpPower / 4

	if Input.is_action_just_pressed("jump") :
		if is_on_floor() || JumpsMade < 2:
			velocity.y = JumpPower
			JumpsMade += 1

	#apply movment
	if direction :
		velocity.x = direction * speed
	else :
		velocity.x = move_toward(velocity.x, 0, speed)

	#dash
	if Input.is_action_pressed("dash") and CanDash :
		Dash = true
		CanDash = false
		$DashTimer.start()
		$DashAgainTimer.start()
	if Input.is_action_pressed("dash") and Input.is_action_pressed("jump") and CanDash :
		Dash = true
		CanDash = false
		$DashTimer.start()
		$DashAgainTimer.start()
	if direction :
		if Dash :
			velocity.x = direction * DashSpeed
			dash.emitting = true
		elif Dash :
			velocity.y = direction * DashSpeed
			dash.emitting = true
		else :
			dash.emitting = false
	dash.scale.x = -1 if direction < 0 else 1

#flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		

#play animations
	if is_on_floor():
		if direction == 0 :
			animated_sprite.play("idle")
		else :
			animated_sprite.play("walk")
	elif (Input.is_action_pressed("jump") and JumpsMade == 2) :
		animated_sprite.play("jump")
	else:
		animated_sprite.play("fall")

	move_and_slide()

func _on_dash_timer_timeout() -> void:
	Dash = false 


func _on_dash_again_timer_timeout() -> void:
	CanDash = true
