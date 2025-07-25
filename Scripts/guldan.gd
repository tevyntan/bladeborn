extends CharacterBody2D

class_name Guldan_Enemy

const speed = 10
var dir: Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var isChasing: bool
var player: CharacterBody2D


var health = 100
var isDead: bool = false 
var taking_damage = false
var isRoaming: bool
var dmg_to_deal = 20
var is_dealing_dmg: bool = false
var meleeattack: bool = false
var meleeactive: bool = false
var Spell = preload("res://Scenes/Enemies/guldan_spell.tscn")

#From variable to show what form guldan is in, true - physical; false - spirit
var form: bool = false


func _ready() -> void:
	#disable boss melee skill at the start
	$GuldanMeleeArea/CollisionShape2D.disabled = true
	
	#While loop to constantly change the boss form
	while not isDead:
		if form:
			form = false
			$GuldanHitBox.collision_mask = 2
		else:
			form = true
			$GuldanHitBox.collision_mask = 1
		await get_tree().create_timer(10.0).timeout

func move(delta):
	if Global.PlayerAlive:
		player = Global.PlayerBody
	
	#flip attack hitbox to side its facing
	if velocity.x < 0:
		$GuldanMeleeArea.scale.x = 1
	elif velocity.x > 0:
		$GuldanMeleeArea.scale.x = -1
	
	if !isDead:
		
		if !taking_damage && isChasing && Global.PlayerAlive:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = (abs(velocity.x) / velocity.x)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * - 50
			velocity.x = knockback_dir.x
		else:
			velocity += dir * speed * delta
			isRoaming = true
	elif isDead:
		velocity.x = 0
	
	#Add Gravity
	if not is_on_floor() && !isDead:
		velocity += get_gravity() * delta
		velocity.x = 0
		
	move_and_slide()

func _physics_process(delta: float) -> void:
	Global.GuldanDmgAmt = dmg_to_deal
	Global.GuldanDmgZone = $GuldanDealDmgArea
	Global.GuldanHealth = health
	if !Global.PlayerAlive:
		isChasing = false
	
	#Enables the melee attack of Guldan when health reaches 50 and below
	if health > 60:
		$GuldanMeleeArea/CollisionShape2D.disabled = true
		meleeactive = false
	if health < 60 and not meleeactive:
		$GuldanMeleeArea/CollisionShape2D.disabled = false
		meleeactive = true
	
	#change collision layer based on form
	if form:
		$".".collision_layer = 1
	else:
		$".".collision_layer = 16
	move(delta)
	handle_animations()
	

func handle_animations():
	
	#Decide which form animations
	var prefix = "Phys."
	if not form:
		prefix = "Spirit."
	
	
	if !isDead && is_dealing_dmg:
		if meleeattack:
			animated_sprite_2d.play(prefix + "Melee")
		else:
			animated_sprite_2d.play(prefix + "Cast")
	else:
		if !isDead && !taking_damage:
			animated_sprite_2d.play(prefix + "Run")
			if dir.x == - 1:
				animated_sprite_2d.flip_h = false
			elif dir.x == 1:
				animated_sprite_2d.flip_h = true
		elif !isDead && taking_damage:
			animated_sprite_2d.play(prefix + "Hurt")
		elif isDead && isRoaming:
			isRoaming = false
			animated_sprite_2d.play(prefix + "Death")
			$CollisionShape2D.queue_free()
			#$GuldanHitBox.queue_free()
			$GuldanDealDmgArea/CollisionShape2D.disabled = true
		

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !isChasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()


func _on_guldan_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.PlayerDmgZone:
		var damage = Global.PlayerDmgAmt
		take_damage(damage)
		

func _on_guldan_deal_dmg_area_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		is_dealing_dmg = true
		await get_tree().create_timer(0.8).timeout
		spell_cast()
		await get_tree().create_timer(5.0).timeout
		$GuldanDealDmgArea/CollisionShape2D.disabled = true
		$GuldanDealDmgArea/CollisionShape2D.disabled = false

func _on_guldan_melee_area_body_entered(body: Node2D) -> void:
	if !meleeattack:
		if body == Global.PlayerBody:
			is_dealing_dmg = true
			meleeattack = true
			await get_tree().create_timer(0.4).timeout
			$GuldanMeleeArea.collision_layer = 1
			# Check overlaps RIGHT after enabling
			var bodies = $GuldanMeleeArea.get_overlapping_bodies()
			var hit = false
			for b in bodies:
				if b == Global.PlayerBody:
					print("player hit")
					health += 10
					hit = true
					break
			
			if not hit:
				print("Attack missed!")
			
			await get_tree().create_timer(0.2).timeout
			$GuldanMeleeArea.collision_layer = 8
			$GuldanMeleeArea/CollisionShape2D.disabled = true
			await get_tree().create_timer(5.0).timeout
			
			$GuldanMeleeArea/CollisionShape2D.disabled = false

func spell_cast():
	var spell = Spell.instantiate()
	spell.global_position = self.global_position
	get_parent().add_child(spell)


func _on_guldan_tracking_radius_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		isChasing = true
	else:
		isChasing = false


func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		isDead = true  


func _on_animated_sprite_2d_animation_finished() -> void:

	if animated_sprite_2d.animation.ends_with("Death"):
		self.queue_free()
	if animated_sprite_2d.animation.ends_with("Hurt"):
		taking_damage = false
	if animated_sprite_2d.animation.ends_with("Cast"):
		is_dealing_dmg = false
	if animated_sprite_2d.animation.ends_with("Melee"):
		is_dealing_dmg = false
		await get_tree().create_timer(0.8).timeout
		meleeattack = false
