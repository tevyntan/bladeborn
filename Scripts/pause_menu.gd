extends Node
@onready var pause_menu: Control = $"."

@onready var settings: Control = $"../Settings"

func _process(_delta: float) -> void:
	var esc_pressed = Input.is_action_just_pressed("Pause")
	if esc_pressed:
		get_tree().paused = true
		pause_menu.show()


func _on_resume_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false


func _on_save_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	settings.back.connect(_on_settings_back)
	pause_menu.hide()
	settings.show()

func _on_settings_back() -> void:
	settings.hide()
	pause_menu.show()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
