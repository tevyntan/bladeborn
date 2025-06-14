extends Control
@onready var powerups: Control = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_health_pressed() -> void:
	powerups.hide()

func _on_invinsible_pressed() -> void:
	powerups.hide()


func _on_fury_pressed() -> void:
	powerups.hide()


func _on_double_jump_pressed() -> void:
	powerups.hide()
