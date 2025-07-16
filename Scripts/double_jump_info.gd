extends Control

@onready var double_jump_info: Control = $"."

func _on_back_pressed() -> void:
	double_jump_info.visible = false
	get_tree().paused = false
