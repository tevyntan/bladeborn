extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.DoubleJumpAvailable = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_save_scene_body_entered(body: Node2D) -> void:
	Global.LoadScene = "res://Scenes/Stages/stage_3.tscn"


func _on_next_scene_body_entered(body: Node2D) -> void:
	$NextScene.set_deferred("monitoring", false)
	get_tree().change_scene_to_file("res://Scenes/Stages/stage_4.tscn")


func _on_stagelabelling_body_entered(body: Node2D) -> void:
	$Player/Camera2D/StageLabel.visible = false
