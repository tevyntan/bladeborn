extends Control

@onready var invincibility_info: Control = $"."

func _on_back_pressed() -> void:
	invincibility_info.visible = false
	get_tree().paused = false
