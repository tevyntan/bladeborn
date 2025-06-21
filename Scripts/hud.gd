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
		$VBoxContainer/Control/Sprite2D.visible = true
		$VBoxContainer/Control/Sprite2D2.visible = false
	else: 
		$VBoxContainer/Control/Sprite2D.visible = false
		$VBoxContainer/Control/Sprite2D2.visible = true
