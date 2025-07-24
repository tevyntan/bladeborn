extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -350.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_dmg_zone: Area2D = $DealDmgZone
var isAttacking = false
var moon = true

var health = 60
var can_take_damage: bool
var isTakingDmg: bool = false
var isDead: bool
var knockback: Vector2 = Vector2.ZERO
var knockback_time: float = 0.0

var max_health = 60
var current_jump_count = 0
var invincibility_activated = false
var invincibility_blocked = false

var ImpactVFXScene = preload("res://Scenes/ImpactVFX.tscn")
@onready var invincible_icon: Control = $"../CanvasLayer/HUD/Powerups/Invincible"

func _ready() -> void:
	Global.PlayerBody = self
	Global.PlayerAlive = true
	can_take_damage = true
	isDead = false
	
	if Global.FuryUnlocked:
		Global.FuryAvailable
	if Global.InvincibilityUnlocked:
		Global.InvincibilityAvailable
	invincibility_activated = false
	invincibility_blocked = false

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
				$DealDmgZone.collision_mask = 1
				set_collision_mask_value(2, true) #swap mask to interact with diff platforms
				set_collision_mask_value(3, false)

			else:
				moon = false
				$DealDmgZone.collision_layer = 2
				$DealDmgZone.collision_mask = 16
				set_collision_mask_value(2, false) #swap mask to interact with diff platforms
				set_collision_mask_value(3, true)
		
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump including double jump. 
		var max_jump_count = 2 if Global.DoubleJumpAvailable else 1
		
		if is_on_floor():
			current_jump_count = 0
			
		if Input.is_action_just_pressed("Jump") and current_jump_count < max_jump_count:
			velocity.y = JUMP_VELOCITY
			current_jump_count += 1

		handle_movement(delta)
		handle_animations()
		check_hitbox()
		handle_fury()
		handle_invincible()
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
	
	#Decide which moon animations
	var prefix = "Full."
	if not moon:
		prefix = "Cres."

	#Animations
	if isTakingDmg:
		animated_sprite_2d.play(prefix + "Dmg")
	elif isAttacking:
		animated_sprite_2d.play(prefix + "Attack")
	else:
		if is_on_floor() && isAttacking == false:
			if direction == 0:
				animated_sprite_2d.play(prefix + "Idle")
			else:
				animated_sprite_2d.play(prefix + "Run")
		elif isAttacking == false: 
			animated_sprite_2d.play(prefix + "Jump")
		
		if Input.is_action_just_pressed("Attack") && isAttacking == false && isTakingDmg == false:
			animated_sprite_2d.play(prefix + "Attack")
			isAttacking = true
			set_damage()
			toggle_attack()
			


#HitBox checker
func check_hitbox():
	if not can_take_damage:
		return
		
	var hitbox_areas = $PlayerHitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is Satyr_enemy:
			damage = Global.SatyrDmgAmt 
		if hitbox.get_parent() is Satyr_spirit:
			damage = Global.SatyrSpiritDmgAmt 
		if hitbox.get_parent() is Mage_enemy:
			damage = Global.MageDmgAmt 
		if hitbox.get_parent() is Mage_spirit:
			damage = Global.MageSpiritDmgAmt 
		if hitbox.get_parent() is Golem_enemy:
			damage = Global.GolemDmgAmt 
		if hitbox.get_parent() is Golem_spirit:
			damage = Global.GolemSpiritDmgAmt 
		if hitbox is Guldan_Spell:
			damage = 10
		if hitbox.get_parent() is Guldan_Enemy:
			damage = Global.GuldanDmgAmt
		
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
			if invincibility_activated and not invincibility_blocked:
				invincibility_blocked = true
				damage = 0
			health -= damage
			Global.PlayerDmgCount +=1
			
			if health <= 0:
				health = 0
				isDead = true
				Global.PlayerAlive = false
				handle_death()
			
			#handles taking damage interrupt attack
			cancel_attack()
			
			#take damage cooldown
			can_take_damage = false
			isTakingDmg = true
			

func handle_death():
	velocity.x = 0
	velocity += get_gravity() * 1
	if moon:
		animated_sprite_2d.play("Full.Death")
	else:
		animated_sprite_2d.play("Cres.Death")
	

#Attack collision model
func toggle_attack():
	var dmg_zone = deal_dmg_zone.get_node("CollisionShape2D")
	await get_tree().create_timer(0.5).timeout
	if isAttacking:
		dmg_zone.disabled = false

#Cancel the attack animation
func cancel_attack():
	$DealDmgZone/CollisionShape2D.disabled = true
	isAttacking = false

#Set Attack Dmg Amount
func set_damage():
	var dmg_amt: int = 10
	Global.PlayerDmgAmt = dmg_amt

#Shows impact vfx when player hits enemy
func show_impact_vfx(position: Vector2):
	var impact = ImpactVFXScene.instantiate()
	get_tree().current_scene.add_child(impact)
	impact.global_position = position

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation.ends_with("Attack"):
		cancel_attack()
	
	if animated_sprite_2d.animation.ends_with("Death"):
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
		self.queue_free()
		

	if animated_sprite_2d.animation == "Full.Dmg" || animated_sprite_2d.animation == "Cres.Dmg":
		isTakingDmg = false
		await get_tree().create_timer(0.5).timeout
		can_take_damage = true
		

func handle_fury():
	if Input.is_action_just_pressed("Fury") && Global.FuryAvailable:
		Global.PlayerDmgAmt *= 2
		SPEED = 400;
		await get_tree().create_timer(10).timeout
		Global.PlayerDmgAmt = Global.PlayerDmgAmt / 2
		SPEED = 300;




func handle_invincible():
	if Input.is_action_just_pressed("Invincible") && Global.InvincibilityAvailable:
		invincibility_activated = true
		invincibility_blocked = false
		await get_tree().create_timer(20).timeout
		invincibility_activated = false
		invincibility_blocked = false
		


func _on_deal_dmg_zone_body_entered(body: Node2D) -> void:
	var impact_pos = body.global_position
	if not body is Satyr_enemy and not body is Satyr_spirit:
		impact_pos.y -= 20
	if body is Guldan_Enemy:
		impact_pos.y -= 40
	show_impact_vfx(impact_pos)
