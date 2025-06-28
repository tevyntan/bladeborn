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
		
	
	
