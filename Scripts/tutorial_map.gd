extends Node2D

@onready var form: Label = $CanvasLayer/Form

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.PlayerFullMoon:
		form.text = "Full Moon"
	else: 
		form.text = "Crescent Moon"
#Show health points
func _on_attack_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		$CanvasLayer/hplabel.visible = true
func _on_attack_body_exited(body: Node2D) -> void:
	if body == Global.PlayerBody:
		$CanvasLayer/hplabel.visible = false


#Show Form
func _on_form_switch_body_entered(body: Node2D) -> void:
	if body == Global.PlayerBody:
		form.visible = true
func _on_form_switch_body_exited(body: Node2D) -> void:
	if body == Global.PlayerBody:
		form.visible = false
