extends Sprite2D

@onready var cooldown: TextureProgressBar = $Cooldown
@onready var key: Label = $Key
@onready var time: Label = $Time
@onready var timer: Timer = $Timer
var timer_bool = false

func _ready() -> void:
	cooldown.max_value = timer.wait_time

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Invincible") && Global.InvincibilityAvailable:
		timer.start()
		timer_bool = true
		Global.InvincibilityAvailable = false
		
	handle_timer(timer_bool)


func _on_timer_timeout() -> void:
	time.text = ""
	cooldown.value = 0
	timer_bool = false
	Global.InvincibilityAvailable = true
	
func handle_timer(bool):
	if bool:
		time.text = "%3.1f" % timer.time_left
		cooldown.value = timer.time_left
		
