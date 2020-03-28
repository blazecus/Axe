extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const MAXSPEED = 150
const AIRSPEED = 300
const DRAG = 200
const GRAVITY = 600
const JUMPSPEED = 250

var velocity = Vector2(0,0)
var action_state = "standing_r"
var on_ground = false
var willjump = 0
var charging = false

func _physics_process(delta):
	on_ground = is_on_floor()
	
	if Input.is_action_pressed("ui_right") and willjump == 0:

		if on_ground:
			velocity.x = MAXSPEED
			action_state = "running_r"
		velocity.x += AIRSPEED * delta
	elif Input.is_action_pressed("ui_left") and willjump == 0:

		if on_ground:
			velocity.x = -MAXSPEED
			action_state = "running_l"
		velocity.x -= AIRSPEED * delta

	elif on_ground and willjump == 0:
		velocity.x = 0
		var new_state = "standing_" + action_state.substr(len(action_state)-1)
		if action_state == "running_r" or action_state == "standing_r":
			new_state = "standing_r"
		action_state = new_state
	
	if willjump > .125:
		velocity.y = -JUMPSPEED
		willjump = 0
	elif willjump > 0:
		willjump += delta

	var dirstate = action_state.substr(len(action_state) - 1, len(action_state))

	if Input.is_action_just_pressed("ui_jump") and on_ground:
		velocity.y -= JUMPSPEED
		action_state = "jumping_" + dirstate
	velocity.y += GRAVITY * delta
	
	if velocity.x < 0:
		velocity.x += DRAG * delta
	elif velocity.x > 0:
		velocity.x -= DRAG * delta
		
	$forwardArm.visible = charging
	$backArm.visible = charging
	if(charging):
		action_state = "throwing_" + action_state
		$forwardArm.play("charge_" + dirstate)
		$backArm.play("charge_" + dirstate)
	else:
		$forwardArm.play("not")
		$backArm.play("not")
	$AnimatedSprite.play(action_state)

	velocity = move_and_slide(velocity, FLOOR)
	
	
func _input(event):
	if event is InputEventMouseButton:

		charging = !charging
