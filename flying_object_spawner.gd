extends Node2D

@export var pieces: Array[PackedScene]          # drop scenes here
@export var spawn_interval: float = 1.29        # seconds
@export var speed: float = 500.0                # passed into piece.start()
@export var y_jitter: float = 100.0             # ± range on Y

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()         # once is enough, goblin
	spawn_loop()

func spawn_loop() -> void:
	while true:
		spawn_piece()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_piece() -> void:
	if pieces.is_empty():
		return

	var scene: PackedScene = pieces.pick_random()
	var piece = scene.instantiate()

	# make a fresh random Y each spawn (keep X the same)
	var offset_y := rng.randf_range(-y_jitter, y_jitter)
	var spawn_pos := Vector2(position.x, position.y + offset_y)
	piece.position = spawn_pos

	# universal speed (assuming your piece has start(speed))
	piece.start(speed)

	# add to scene safely
	get_parent().add_child.call_deferred(piece)
