extends Control

@onready var double_jump_screen: Control = $"."
@onready var double_jump_hud: Control = $"../../HUD/DoubleJump"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	double_jump_screen.visible = false
	double_jump_hud.show()
	Global.DoubleJumpAvailable = true
	
	
