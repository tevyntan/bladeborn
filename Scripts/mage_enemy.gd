extends CharacterBody2D

class_name Mage_enemy

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

func _ready() -> void:
	pass
	
func move(delta):
	if Global.PlayerAlive:
		player = Global.PlayerBody
	
	#flip attack hitbox to side its facing
	if velocity.x < 0:
		$MageDealDmgArea.scale.x = -1
	elif velocity.x > 0:
		$MageDealDmgArea.scale.x = 1
		
	
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
	Global.MageDmgAmt = dmg_to_deal
	Global.MageDmgZone = $MageDealDmgArea
	
	if !Global.PlayerAlive:
		isChasing = false
	
	move(delta)
	handle_animations()
	

func handle_animations():
	if !isDead && is_dealing_dmg:
		animated_sprite_2d.play("Attack")
	else:
		if !isDead && !taking_damage:
			animated_sprite_2d.play("Run")
			if dir.x == - 1:
				animated_sprite_2d.flip_h = true
			elif dir.x == 1:
				animated_sprite_2d.flip_h = false
		elif !isDead && taking_damage:
			animated_sprite_2d.play("Hurt")
		elif isDead && isRoaming:
			isRoaming = false
			animated_sprite_2d.play("Death")
			$CollisionShape2D.queue_free()
			$MageHitBox.queue_free()
			$MageDealDmgArea.queue_free()
	
		

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !isChasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()

func _on_mage_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.PlayerDmgZone:
		var damage = Global.PlayerDmgAmt
		take_damage(damage)
		


func _on_mage_deal_dmg_area_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		is_dealing_dmg = true
		#change collision timer to match animation for player to get hit
		await get_tree().create_timer(0.6).timeout 
		$MageDealDmgArea.collision_layer = 1
		await get_tree().create_timer(0.2).timeout
		$MageDealDmgArea.collision_layer = 8

func _on_mage_tracking_radius_body_entered(body: Node2D) -> void:
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
	if animated_sprite_2d.animation == "Death":
		#await get_tree().create_timer(0.3).timeout
		self.queue_free()
	if animated_sprite_2d.animation == "Hurt":
		taking_damage = false
	if animated_sprite_2d.animation == "Attack":
		is_dealing_dmg = false
