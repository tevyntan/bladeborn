extends Control

@onready var fury_info: Control = $"."

func _on_back_pressed() -> void:
	fury_info.visible = false
	get_tree().paused = false
