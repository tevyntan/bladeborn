extends Control

@onready var label: Label = $VBoxContainer/Heart/Label
@onready var double_jump: Control = $DoubleJump

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(Global.PlayerHeath)

	if Global.PlayerFullMoon:
		$VBoxContainer/MoonStyle/Full_logo.visible = true
		$VBoxContainer/MoonStyle/Crescent_logo.visible = false

	else: 
		$VBoxContainer/MoonStyle/Full_logo.visible = false
		$VBoxContainer/MoonStyle/Crescent_logo.visible = true
