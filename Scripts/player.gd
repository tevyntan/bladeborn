extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_dmg_zone: Area2D = $DealDmgZone
var isAttacking = false
var moon = true

var health = 40
var can_take_damage: bool
var isDead: bool

func _ready() -> void:
	Global.PlayerBody = self
	Global.PlayerAlive = true
	can_take_damage = true
	isDead = false 

func _physics_process(delta: float) -> void:
	Global.PlayerDmgZone = deal_dmg_zone
	if !isDead:
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
		
		handle_animations()
		check_hitbox()
	
#Play animations
func handle_animations():
	# Get the input direction: -1, 0, 1,  and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	#Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
		deal_dmg_zone.scale.x = 1
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		deal_dmg_zone.scale.x = - 1
	# Full Moon Actions
	
	#To be added, hurt animation
	#if !can_take_damage:
		#pass
	#else:
	if moon == true:
		if is_on_floor() && isAttacking == false:
			if direction == 0:
				animated_sprite_2d.play("Full.Idle")
			else:
				animated_sprite_2d.play("Full.Run")
		elif isAttacking == false: 
			animated_sprite_2d.play("Full.Jump")
		
		if Input.is_action_just_pressed("Attack") && isAttacking == false:
			animated_sprite_2d.play("Full.Attack")
			set_damage()
			toggle_attack()
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
		
		if Input.is_action_just_pressed("Attack") && isAttacking == false:
			animated_sprite_2d.play("Cres.Attack")
			set_damage()
			toggle_attack()
			isAttacking = true
		
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

#HitBox checker
func check_hitbox():
	var hitbox_areas = $PlayerHitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is Satyr_enemy:
			damage = Global.SatyrDmgAmt 
	
	if can_take_damage:
		take_damage(damage)

#Player take damage
func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			
			if health <= 0:
				health = 0
				isDead = true
				Global.PlayerAlive = false
				handle_death()
			#take damage cooldown
			can_take_damage = false
			await get_tree().create_timer(1.0).timeout
			can_take_damage = true

func handle_death():
	animated_sprite_2d.play("Full.Death")

#Attack collision model
func toggle_attack():
	var dmg_zone = deal_dmg_zone.get_node("CollisionShape2D")
	await get_tree().create_timer(0.5).timeout
	dmg_zone.disabled = false

#Set Attack Dmg Amount
func set_damage():
	var dmg_amt: int = 10
	Global.PlayerDmgAmt = dmg_amt

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Full.Attack":
		$DealDmgZone/CollisionShape2D.disabled = true
		isAttacking = false
	if animated_sprite_2d.animation == "Cres.Attack":
		$DealDmgZone/CollisionShape2D.disabled = true
		isAttacking = false
	if animated_sprite_2d.animation == "Full.Death":
		await get_tree().create_timer(1.0).timeout
		self.queue_free()
