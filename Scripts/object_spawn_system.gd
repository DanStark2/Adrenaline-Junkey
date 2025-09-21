extends Node2D

@export var ground_pieces: Array[PackedScene]    # drag your ground scenes into here
@export var spawn_interval: float = 1.29      # how often to spawn
@export var speed: float = 500.0                 # universal speed for all spawned pieces

func _ready() -> void:
	# start spawning on repeat
	spawn_loop()

func spawn_loop() -> void:
	while true:
		spawn_piece()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_piece() -> void:
	if ground_pieces.is_empty():
		return

	# pick one at random, or cycle if you want
	var scene: PackedScene = ground_pieces.pick_random()
	var piece = scene.instantiate()
	
	# place it at spawner’s position
	piece.position = position
	
	# set the universal speed
	piece.start(speed)
	
	# throw it into the scene
	get_parent().add_child.call_deferred(piece)
