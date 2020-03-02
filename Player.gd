extends KinematicBody2D



var velocity = Vector2(0,0)
var action_state = "standing_right"

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = 175
		action_state = "running_right"

	elif Input.is_action_pressed("ui_left"):
		velocity.x = -175
		action_state = "running_left"
		
	elif Input.is_action_just_pressed("ui_jump") and action_state.substr(0, 4) != "jump":
		velocity.y = -200
		action_state = "jumping_" + action_state.substr(len(action_state) - 4, len(action_state))
	else:
		velocity.x = 0
		var new_state = "standing_left"
		if action_state == "running_right" or action_state == "standing_right":
			new_state = "standing_right"
		action_state = new_state
		
	velocity.y += 200 * delta
			
			
	
	get_node("AnimatedSprite").play(action_state)
	move_and_slide(velocity)
