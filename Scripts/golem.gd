extends CharacterBody2D

class_name Golem_enemy

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
var is_attacking: bool = false

func _ready() -> void:
	pass
	
func move(delta):
	if Global.PlayerAlive:
		player = Global.PlayerBody
	
	#flip attack hitbox to side its facing
	if velocity.x < 0:
		$GolemDealDmgArea.scale.x = -1
	elif velocity.x > 0:
		$GolemDealDmgArea.scale.x = 1
		
	
	if !isDead:
		if is_dealing_dmg:
			velocity.x = 0
		elif !taking_damage && isChasing && Global.PlayerAlive && !is_dealing_dmg:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = (abs(velocity.x) / velocity.x)
		elif taking_damage:
			pass
			#var knockback_dir = position.direction_to(player.position) * - 20
			#velocity.x = knockback_dir.x
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
	Global.GolemDmgAmt = dmg_to_deal
	Global.GolemDmgZone = $GolemDealDmgArea
	
	if !Global.PlayerAlive:
		isChasing = false
	
	move(delta)
	handle_animations(delta)
	

func handle_animations(delta):
	if !isDead && is_dealing_dmg:
		animated_sprite_2d.play("Attack")
		if is_attacking:
			dmg_animate(delta)
	else:
		is_attacking = false
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
			$GolemHitBox.queue_free()
			$GolemDealDmgArea/CollisionShape2D.disabled = true
		

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !isChasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front()


func _on_golem_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.PlayerDmgZone:
		var damage = Global.PlayerDmgAmt
		take_damage(damage)
		


func _on_golem_deal_dmg_area_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		is_dealing_dmg = true
		await get_tree().create_timer(0.6).timeout 
		is_attacking = true

func dmg_animate(delta):
	$GolemDmgArea.collision_layer = 1
	$GolemDmgArea2.collision_layer = 1
	$GolemDmgArea/CollisionShape2D.position.x += 1.9
	$GolemDmgArea2/CollisionShape2D.position.x -= 2.1
	
	

func _on_golem_tracking_radius_body_entered(body: Node2D) -> void:
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
		is_attacking = false
		$GolemDmgArea.collision_layer = 8
		$GolemDmgArea2.collision_layer = 8
		$GolemDmgArea/CollisionShape2D.position.x = 31.0
		$GolemDmgArea2/CollisionShape2D.position.x = -25.0
		
