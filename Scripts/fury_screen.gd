extends Control

@onready var fury_screen: Control = $"."
@onready var fury_hud: Control = $"../../HUD/Powerups/Fury"
@onready var fury_info: Control = $"../FuryInfo"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	fury_screen.visible = false
	fury_hud.show()
	Global.FuryAvailable = true
	fury_info.visible = true
