extends CharacterBody2D

@export var SPEED_LEFT = 400.0   # faster left
@export var HEALTH = 3   # faster left
@export var SPEED_RIGHT = 200.0  # slower right
@export var JUMP_VELOCITY = 500
@export var GRAVITY_MULTIPLIER = 2
@export var JUMPS = 1 #Double Jumps
@export var DASH_LENGH = 3200 #How far the dash launches
@export var DASH_COOLTIME = 3 #Dash cooldown time
@onready var DASH_COOLDOWN = $DashCooldown
var CURRENTLY_DASHING = false
@onready var WHILE_DASHING = $whileDashing
@export var DASH_LENGTH_TIME = 0.1
@onready var GRAPPLE_LINE = $GrappleLine
@onready var MOUSE_POS = get_global_mouse_position()
@onready var GRAPPLE_TIMER = $GrappleTimer
@onready var DAMAGE_OVERLAY = get_parent().get_node("DamageOverlay")
@onready var ANIM = $AnimationPlayer
@onready var DEATH_OVERLAY = get_parent().get_node("GameOverOverLay")

func _ready() -> void:
	position = Vector2.ZERO
func _physics_process(delta: float) -> void:
	
	Globals.Health = HEALTH
	
	if HEALTH <= 0:
		death()
		
	
	
	
	#if Input.is_action_just_pressed("grapple"):
		#grapple()
		#velocity.y = clamp(velocity.y, -DASH_LENGH/4, DASH_LENGH/4)
	if !CURRENTLY_DASHING:
		velocity.x = clamp(velocity.x, -SPEED_RIGHT, SPEED_RIGHT)
	elif CURRENTLY_DASHING:
		velocity.x = clamp(velocity.x, -DASH_LENGH, DASH_LENGH)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_MULTIPLIER
		
	# Handle Dash
	if Input.is_action_just_pressed("dash") and DASH_COOLDOWN.is_stopped():
		$CPUParticles2D.emitting = true
		CURRENTLY_DASHING = true
		WHILE_DASHING.start(DASH_LENGTH_TIME)
		velocity.x += DASH_LENGH
		DASH_COOLDOWN.start(DASH_COOLTIME)
		print(velocity.x)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		JUMPS = 1
	elif Input.is_action_just_pressed("jump") and JUMPS>=1 and !is_on_floor():
		JUMPS -= 1
		velocity.y = -JUMP_VELOCITY
		$CPUParticles2D.emitting = true

	# Handle left/right input with different speeds.
	var direction := Input.get_axis("left", "right")
	if direction > 0:
		# moving right
		velocity.x += SPEED_RIGHT * direction
	elif direction < 0:
		# moving left
		velocity.x += SPEED_LEFT * direction
	else:
		velocity.x = move_toward(velocity.x, 0, max(SPEED_LEFT, SPEED_RIGHT))

	move_and_slide()

func grapple():
	GRAPPLE_TIMER.start(1)
	GRAPPLE_LINE.visible = true
	GRAPPLE_LINE.points =[Vector2.ZERO, to_local(get_global_mouse_position())]
	launch_to_mouse(DASH_LENGH)	

func _on_while_dashing_timeout() -> void:
	CURRENTLY_DASHING = false
	print("Finished Dash After", DASH_LENGTH_TIME)
	
func launch_to_mouse(force: float) -> void:
	CURRENTLY_DASHING = true
	WHILE_DASHING.start(DASH_COOLTIME)
	var mouse_global := get_global_mouse_position()
	var dir := (mouse_global - global_position).normalized()
	velocity = dir * force   # yeet the player
func death():
	if DEATH_OVERLAY.is_in_group("GOOL"):
		DEATH_OVERLAY.visible = true
		get_tree().paused = true
	else: 
		print("did not find 'DEATH_OVERLAY'")
	
func damage():
	DAMAGE_OVERLAY.run()
	HEALTH -= 1
	ANIM.play("setback")
	


func _on_grapple_timer_timeout() -> void:
	GRAPPLE_LINE.visible = false
	
func knockback(amount:int):
	print("knockback:", amount)
	velocity.x += amount * -1
	
