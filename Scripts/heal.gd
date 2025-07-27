extends Area2D

class_name Heal
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		animation_player.play("pickup")
