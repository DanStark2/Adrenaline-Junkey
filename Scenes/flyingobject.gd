extends StaticBody2D

@export var speed: float = 200.0        # pixels/sec
@export var lifetime: float = 8.0      # seconds before auto-delete
var _velocity: Vector2 = Vector2.RIGHT # default direction
@onready var ANIM = $AnimationPlayer

func _ready() -> void:
	# Auto-despawn after `lifetime`
	despawn_after(lifetime)
	ANIM.play("SPIN")

func _physics_process(delta: float) -> void:
	position -= _velocity * speed * delta

func start(spd: float) -> void:
	speed = spd

func set_direction(dir: Vector2) -> void:
	# Optional: set custom direction (e.g., to shoot left: set_direction(Vector2.LEFT))
	_velocity = dir.normalized()

func despawn_after(seconds: float) -> void:
	# Wait then yeet
	await get_tree().create_timer(seconds).timeout
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("target hit", body)
	if body.is_in_group("player"):
		body.knockback(1000)
