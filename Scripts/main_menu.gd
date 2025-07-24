extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var settings: Control = $Settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_buttons.visible = true
	settings.visible = false
	settings.back.connect(_on_settings_back)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial_map.tscn")


func _on_load_pressed() -> void:
	get_tree().change_scene_to_file(Global.LoadScene)


func _on_settings_pressed() -> void:
	main_menu_buttons.visible = false
	settings.visible = true
	
func _on_settings_back()-> void:
	_ready()
	

func _on_quit_pressed() -> void:
	get_tree().quit()
