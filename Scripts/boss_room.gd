extends Node2D

@onready var boss_bar: ProgressBar = $BossUI/BossBar
@onready var damage_bar: ProgressBar = $BossUI/BossBar/DamageBar
@onready var timer: Timer = $BossUI/BossBar/Timer

var Bossdead: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.DoubleJumpAvailable = true
	damage_bar.value = Global.GuldanHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Bossdead:
		return
	if Global.GuldanHealth == 0:
		Bossdead = true
		$BossUI.queue_free()
	else:
		boss_bar.value = Global.GuldanHealth
	if boss_bar.value < damage_bar.value and timer.is_stopped():
		timer.start()
	elif boss_bar.value > damage_bar.value:
		# Heal case — snap immediately
		damage_bar.value = boss_bar.value
	

func _on_timer_timeout() -> void:
	damage_bar.value = Global.GuldanHealth


func _on_save_scene_body_entered(body: Node2D) -> void:
	Global.LoadScene = "res://Scenes/boss_room.tscn"
