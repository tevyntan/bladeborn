extends CharacterBody2D

class_name Guldan_Enemy

const speed = 10
var dir: Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var isChasing: bool
var player: CharacterBody2D


var health = 30
var isDead: bool = false 
var taking_damage = false
var isRoaming: bool
var dmg_to_deal = 20
var is_dealing_dmg: bool = false
var Spell = preload("res://Scenes/Enemies/guldan_spell.tscn")

#From variable to show what form guldan is in, true - physical; false - spirit
var form: bool = false


func _ready() -> void:
	#While loop to constantly change the boss form
	while not isDead:
		await get_tree().create_timer(2.0).timeout
		if form:
			form = false
			$GuldanHitBox.collision_mask = 2
		else:
			form = true
			$GuldanHitBox.collision_mask = 1

func move(delta):
	if Global.PlayerAlive:
		player = Global.PlayerBody
	
	#flip attack hitbox to side its facing
	if velocity.x < 0:
		$GuldanDealDmgArea.scale.x = 1
	elif velocity.x > 0:
		$GuldanDealDmgArea.scale.x = -1
		
	
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
	
	if !Global.PlayerAlive:
		isChasing = false
	
	move(delta)
	handle_animations()
	

func handle_animations():
	
	#Decide which form animations
	var prefix = "Phys."
	if not form:
		prefix = "Spirit."
	
	
	if !isDead && is_dealing_dmg:
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
		await get_tree().create_timer(2.0).timeout
		$GuldanDealDmgArea/CollisionShape2D.disabled = true
		$GuldanDealDmgArea/CollisionShape2D.disabled = false

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
