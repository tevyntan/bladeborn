extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var double_jump_screen: Control = $"../CanvasLayer/PowerupScenes/DoubleJumpScreen"
@onready var invincibility_screen: Control = $"../CanvasLayer/PowerupScenes/InvincibilityScreen"
@onready var fury_screen: Control = $"../CanvasLayer/PowerupScenes/FuryScreen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		animation_player.play("pickup")
		$AnimatedSprite2D.play("default")
		await $AnimatedSprite2D.animation_finished
		get_tree().paused = true
		
		match Global.PowerupCounter:
			0:
				double_jump_screen.show()
				Global.PowerupCounter+=1
			1:
				invincibility_screen.show()
				Global.PowerupCounter+=1
			2:
				fury_screen.show()
				Global.PowerupCounter+=1
		
		
