extends Control

@onready var double_jump_screen: Control = $"."
@onready var double_jump_hud: Control = $"../../HUD/Powerups/DoubleJump"
@onready var double_jump_info: Control = $"../DoubleJumpInfo"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	double_jump_screen.visible = false
	double_jump_hud.show()
	Global.DoubleJumpAvailable = true
	double_jump_info.visible = true
	
	
	
	
