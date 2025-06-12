extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var settings_pop_up: Panel = $SettingsPopUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_buttons.visible = true
	settings_pop_up.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_load_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	main_menu_buttons.visible = false
	settings_pop_up.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_settings_pressed() -> void:
	_ready()
