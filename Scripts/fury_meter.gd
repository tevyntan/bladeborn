extends Control
@onready var progress_bar: ProgressBar = $ProgressBar

func _process(delta: float) -> void:
	progress_bar.value = Global.PlayerDmgCount * 50
	if progress_bar.value == 100:
		Global.FuryMeterFull = true
	if progress_bar.value == 100 && Global.FuryUnlocked:
		Global.FuryAvailable = true
	if Input.is_action_just_pressed("Fury") && Global.FuryAvailable:
		Global.PlayerDmgCount = 0;
		Global.FuryAvailable = false;
		Global.FuryMeterFull = false;
		
