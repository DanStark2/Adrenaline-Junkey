extends CharacterBody2D

const SPEED_LEFT = 400.0   # faster left
const SPEED_RIGHT = 200.0  # slower right
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle left/right input with different speeds.
	var direction := Input.get_axis("left", "right")
	if direction > 0:
		# moving right
		velocity.x = SPEED_RIGHT * direction
	elif direction < 0:
		# moving left
		velocity.x = SPEED_LEFT * direction
	else:
		velocity.x = move_toward(velocity.x, 0, max(SPEED_LEFT, SPEED_RIGHT))

	move_and_slide()
