# SmoothSprite2D.gd
extends Sprite2D

## How quickly the sprite moves to its target position. Higher values are faster.
@export var interpolate_speed: float = 20.0
@export var flip_speed: float = 4.0
@export var cardbackTexture: Texture2D
var mainTexture: Texture2D
var initialXScale: float
var flipped = true
var y_offset: float = 0

# The target global position the sprite will smoothly move towards.
var target_global_position: Vector2

# The sprite's initial local position relative to its parent.
var _offset_from_parent: Vector2

func _ready() -> void:
	mainTexture = texture
	texture = cardbackTexture
	initialXScale = scale.x
	# Defer the setup to ensure the entire scene tree is ready,
	# guaranteeing we get the correct initial global positions.
	call_deferred("setup")


func setup() -> void:
	var parent_node = get_parent()
	# Ensure the parent is a valid Node2D.
	if not is_instance_valid(parent_node) or not parent_node is Node2D:
		push_warning("SmoothSprite2D requires a Node2D parent to function correctly.")
		set_process(false)
		return

	# Calculate and store the initial offset from the parent node.
	# This allows us to maintain the sprite's original relative position.
	_offset_from_parent = self.position
	target_global_position = self.global_position

	# By setting 'as_top_level' to true, the sprite's transform is no longer
	# directly tied to its parent's. This is crucial as it allows us to
	# manually control and interpolate its global position.
	set_as_top_level(true)
	
	# After making the node top-level, its global_position can be reset.
	# We must re-assert its correct global position to avoid a one-frame jump.
	self.global_position = target_global_position


func _process(delta: float) -> void:
	# HANDLE LERPING
	var parent_node = get_parent()
	if not is_instance_valid(parent_node):
		return

	# Calculate the intended target position. This is where the sprite would be
	# if it were still a direct child of the parent. This detects the parent's movement.
	target_global_position = parent_node.global_position + _offset_from_parent + Vector2(0, y_offset)

	# Interpolate from the current position to the target position.
	# This uses an exponential decay formula (1.0 - exp(-delta * interpolate_speed))
	# which ensures the movement is smooth and independent of the frame rate. [1]
	global_position = global_position.lerp(target_global_position, 1.0 - exp(-delta * interpolate_speed))
	
	# HANDLE FLIPPING OVER
	if flipped:
		scale.x -= flip_speed * delta
		if scale.x <= 0:
			flipped = false
			texture = mainTexture
			scale.x = 0
	if not flipped and scale.x != initialXScale:
		scale.x += flip_speed * delta
		if scale.x >= initialXScale:
			scale.x = initialXScale
