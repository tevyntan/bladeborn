extends Control

@onready var double_jump: Control = $DoubleJump

var hearts_list : Array[TextureRect]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $VBoxContainer/Hearts.get_children():
		hearts_list.append(child)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_health = Global.PlayerHeath
	update_heart_display(player_health)
	if Global.PlayerFullMoon:
		$VBoxContainer/MoonStyle/Full_logo.visible = true
		$VBoxContainer/MoonStyle/Crescent_logo.visible = false

	else: 
		$VBoxContainer/MoonStyle/Full_logo.visible = false
		$VBoxContainer/MoonStyle/Crescent_logo.visible = true

func update_heart_display(player_health):
	for i in range(hearts_list.size()):
		hearts_list[i].visible = (i * 20) < player_health
