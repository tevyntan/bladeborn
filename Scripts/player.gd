extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_dmg_zone: Area2D = $DealDmgZone
var isAttacking = false
var moon = true

var health = 40
var can_take_damage: bool
var isTakingDmg: bool = false
var isDead: bool
var knockback: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0
#
var current_jump_count = 0



func _ready() -> void:
	Global.PlayerBody = self
	Global.PlayerAlive = true
	can_take_damage = true
	isDead = false
	# 
	Global.DoubleJumpAvailable = false

func _physics_process(delta: float) -> void:
	Global.PlayerFullMoon = moon
	Global.PlayerDmgZone = deal_dmg_zone
	Global.PlayerHeath = health
	
	if !isDead:
		# Moon Style
		if Input.is_action_just_pressed("Moon_Change"):
			if moon == false:
				moon = true
				$DealDmgZone.collision_layer = 1
			else:
				moon = false
				$DealDmgZone.collision_layer = 2
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		# 
		var max_jump_count = 2 if Global.DoubleJumpAvailable else 1
		
		if is_on_floor():
			current_jump_count = 0
			
		if Input.is_action_just_pressed("Jump") and current_jump_count < max_jump_count:
			velocity.y = JUMP_VELOCITY
			current_jump_count += 1

		handle_movement(delta)
		handle_animations()
		check_hitbox()
	move_and_slide()

func handle_movement(delta):
	# Get the input direction: -1, 0, 1,  and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	#Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
		deal_dmg_zone.scale.x = 1
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		deal_dmg_zone.scale.x = - 1
	
	if knockback_time > 0 && !can_take_damage:
		velocity.x = knockback.x
		knockback_time -= delta
		
		if knockback_time <= 0:
			knockback = Vector2.ZERO
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


#Play animations
func handle_animations():
	var direction := Input.get_axis("Left", "Right")
	
	# Full Moon Actions
	if moon == true:
		if isTakingDmg:
			animated_sprite_2d.play("Full.Dmg")
		else:
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
		if isTakingDmg:
			animated_sprite_2d.play("Cres.Dmg")
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
		
	
	
	
	

#HitBox checker
func check_hitbox():
	var hitbox_areas = $PlayerHitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is Satyr_enemy:
			damage = Global.SatyrDmgAmt 
		if hitbox.get_parent() is Satyr_spirit:
			damage = Global.SatyrDmgAmt 
		
		
		if can_take_damage:
			take_damage(damage)
			var knockback_direction = (self.global_position - hitbox.global_position).normalized()
			handle_knockback(knockback_direction, 1.00, 0.20)

func handle_knockback(direction, force, knockback_duration) -> void:
	knockback = direction * force * SPEED
	knockback_time = knockback_duration

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
			isTakingDmg = true
			await get_tree().create_timer(1.0).timeout
			can_take_damage = true

func handle_death():
	if moon:
		animated_sprite_2d.play("Full.Death")
	else:
		animated_sprite_2d.play("Cres.Death")
	

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
		get_tree().reload_current_scene()
		self.queue_free()
		
	if animated_sprite_2d.animation == "Cres.Death":
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
		self.queue_free()
	if animated_sprite_2d.animation == "Full.Dmg" || animated_sprite_2d.animation == "Cres.Dmg":
		isTakingDmg = false
	
