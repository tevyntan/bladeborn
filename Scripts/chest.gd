extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var powerups: Control = $"../CanvasLayer/Powerups"
@onready var double_jump_screen: Control = $"../CanvasLayer/PowerupScenes/DoubleJumpScreen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		animation_player.play("pickup")
		double_jump_screen.show()
