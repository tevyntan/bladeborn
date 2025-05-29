extends CharacterBody2D

class_name Satyr_enemy

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

func _ready() -> void:
	isChasing = true
	
func move(delta):
	if Global.PlayerAlive:
		player = Global.PlayerBody
	
	if !isDead:
		isRoaming = true
		if !taking_damage && isChasing && Global.PlayerAlive:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = (abs(velocity.x) / velocity.x)
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * - 50
			velocity.x = knockback_dir.x
		else:
			velocity =+ dir * speed * delta
	elif isDead:
		velocity.x = 0
	move_and_slide()

func _physics_process(delta: float) -> void:
	Global.SatyrDmgAmt = dmg_to_deal
	Global.SatyrDmgZone = $SatyrDealDmgArea
	
	if Global.PlayerAlive:
		isChasing = true
	else:
		isChasing = false
	move(delta)
	move_and_slide()
	handle_animations()

func handle_animations():
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

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.0, 1.5, 2.0])
	if !isChasing:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])

func choose(array):
	array.shuffle()
	return array.front()


func _on_satyr_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.PlayerDmgZone:
		var damage = Global.PlayerDmgAmt
		take_damage(damage)
		

func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		isDead = true  


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Death":
		await get_tree().create_timer(1.0).timeout
		self.queue_free()
	if animated_sprite_2d.animation == "Hurt":
		taking_damage = false
