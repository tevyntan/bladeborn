extends Control

@onready var invincibility_screen: Control = $"."
@onready var invincibility_hud: Control = $"../../HUD/Powerups/Invincible"
@onready var invincibility_info: Control = $"../InvincibilityInfo"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	invincibility_screen.visible = false
	invincibility_hud.show()
	Global.InvincibilityUnlocked = true
	Global.InvincibilityAvailable = true
	invincibility_info.visible = true
	
	
	
	
