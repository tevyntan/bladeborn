extends Sprite2D
@onready var key: Label = $Key
@onready var cooldown: TextureProgressBar = $Cooldown
@onready var time: Label = $Time
@onready var timer: Timer = $Timer
var timer_bool = false

func _ready() -> void:
	cooldown.max_value = timer.wait_time

func _process(delta: float) -> void:
	if Global.FuryAvailable:
		cooldown.value = 0
		if Input.is_action_just_pressed("Fury"):
			timer.start()
			timer_bool = true
			cooldown.value = 0 
	handle_timer(timer_bool)

func _on_timer_timeout() -> void:
	time.text = "10.0"
	cooldown.value = 100
	timer_bool = false
	
func handle_timer(bool):
	if bool:
		time.text = "%3.1f" % timer.time_left
		cooldown.value = cooldown.max_value- timer.time_left
		
