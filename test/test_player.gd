extends GutTest

var player 

func before_each() -> void:
	player = preload("res://Scenes/player.tscn").instantiate()
	add_child(player)
	await get_tree().process_frame
	
	
func after_each() -> void:
	player.queue_free()
	
	
func test_initial_health() -> void:
	assert_eq(player.health, player.max_health, "Player should start with full health")
	
	
func test_jumping() -> void:
	Input.action_press("Jump")
	player._physics_process(1.0/60.0)
	Input.action_release("Jump")
	assert_true(player.velocity.y < 0, "Player expected to move upwards upon jump input")
		
		
func test_form() -> void:
	Input.action_press("Moon_Change")
	player._physics_process(1.0/60.0)
	Input.action_release("Moon_Change")
	assert_true(player.moon == false, "Player expected to change to crescent moon form")
	Input.action_press("Moon_Change")
	player._physics_process(1.0/60.0)
	Input.action_release("Moon_Change")
	assert_true(player.moon == true, "Player expected to change back to ful moon form")
	
func test_right() -> void:
	var initial_position = player.global_position
	Input.action_press("Right")
	player._physics_process(1.0/60.0)
	Input.action_release("Right")
	var final_position = player.global_position
	assert_true(final_position > initial_position, "Player expected to move right upon D input")
		
	
func test_left() -> void:
	var initial_position = player.global_position
	Input.action_press("Left")
	player._physics_process(1.0/60.0)
	Input.action_release("Left")
	var final_position = player.global_position
	assert_true(final_position < initial_position, "Player expected to move left upon A input")
		
