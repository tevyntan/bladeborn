extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.PowerupCounter = 1
	Global.DoubleJumpUnlocked = true
	Global.DoubleJumpAvailable = true
	Global.InvincibilityUnlocked = false
	Global.InvincibilityAvailable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_save_scene_body_entered(body: Node2D) -> void:
	if Global.LoadScene != scene_file_path:
		$Player/Camera2D/SavedLabel.visible = true
	Global.LoadScene = "res://Scenes/Stages/stage_3.tscn"
	await get_tree().create_timer(2).timeout
	$Player/Camera2D/SavedLabel.visible = false


func _on_next_scene_body_entered(body: Node2D) -> void:
	$NextScene.set_deferred("monitoring", false)
	get_tree().change_scene_to_file("res://Scenes/Stages/stage_4.tscn")


func _on_stagelabelling_body_entered(body: Node2D) -> void:
	$Player/Camera2D/StageLabel.visible = false
