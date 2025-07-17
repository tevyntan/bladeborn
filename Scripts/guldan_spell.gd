extends Area2D

class_name Guldan_Spell

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed = 250
var maximum_distance = 500.0
var player: CharacterBody2D
var start_position: Vector2 = Vector2.ZERO
var hitting: bool = false


func _ready() -> void:
	player = Global.PlayerBody as CharacterBody2D
	start_position = global_position
	animation_player.play("Moving")
	

func move(delta):
	if hitting or not player:
		return
	
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	
func _physics_process(delta: float) -> void:
	move(delta)
	
	var distance_travelled = start_position.distance_to(global_position)
	if distance_travelled >= maximum_distance:
		hitting = true
		animation_player.play("Hit")
		await get_tree().create_timer(0.5).timeout 
		collision_layer = 1

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		hitting = true
		animation_player.play("Hit")
		await get_tree().create_timer(0.5).timeout 
		collision_layer = 1
