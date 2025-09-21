extends RigidBody2D

@export var speed: float = 200.0   # horizontal pixels/sec
@export var lifetime: float = 8.0  # seconds before auto-delete

func _ready() -> void:
	sleeping = false
	# give it that sideways shove but keep gravity alive
	linear_velocity = Vector2.LEFT * speed
	despawn_after(lifetime)

func start(spd: float) -> void:
	speed = spd
	linear_velocity.x = -speed  # only touch X so gravity can do Y

func despawn_after(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	queue_free()
