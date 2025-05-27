extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var isAttacking = false
var moon = true


func _physics_process(delta: float) -> void:
	# Moon Style
	if Input.is_action_just_pressed("Moon_Change"):
		if moon == false:
			moon = true
		else:
			moon = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction: -1, 0, 1,  and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	
	#Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	#Play animations
	# Full Moon Actions
	if moon == true:
		if is_on_floor() && isAttacking == false:
			if direction == 0:
				animated_sprite_2d.play("Full.Idle")
			else:
				animated_sprite_2d.play("Full.Run")
		elif isAttacking == false: 
			animated_sprite_2d.play("Full.Jump")
		
		if Input.is_action_just_pressed("Attack"):
			animated_sprite_2d.play("Full.Attack")
			isAttacking = true
	# Crescent Moon Actions, duplicated
	else: 
		if is_on_floor() && isAttacking == false:
			if direction == 0:
				animated_sprite_2d.play("Cres.Idle")
			else:
				animated_sprite_2d.play("Cres.Run")
		elif isAttacking == false: 
			animated_sprite_2d.play("Cres.Jump")
		
		if Input.is_action_just_pressed("Attack"):
			animated_sprite_2d.play("Cres.Attack")
			isAttacking = true
	
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Full.Attack":
		isAttacking = false
	if animated_sprite_2d.animation == "Cres.Attack":
		isAttacking = false
