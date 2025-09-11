extends CharacterBody2D

# Настройки движения
@export var thrust_power : float = 800.0
@export var rotation_speed : float = 3.0
@export var max_speed : float = 400.0
@export var friction : float = 0.98
@export var rotation_friction : float = 0.95

# Внешние силы (гравитация будет добавляться сюда)
var external_forces : Vector2 = Vector2.ZERO
var angular_velocity : float = 0.0

func _physics_process(delta):
	handle_input(delta)
	apply_rotation(delta)
	apply_external_forces()
	apply_friction()
	limit_max_speed()
	move_and_slide()

func handle_input(delta):
	# Движение вперед (W)
	if Input.is_action_pressed("move_forward"):
		var thrust_vector = Vector2(thrust_power, 0).rotated(rotation)
		velocity += thrust_vector * delta
	
	# Боковое движение (A/D)
	if Input.is_action_pressed("move_left"):
		var side_thrust = Vector2(0, -thrust_power * 0.7).rotated(rotation)
		velocity += side_thrust * delta
	
	if Input.is_action_pressed("move_right"):
		var side_thrust = Vector2(0, thrust_power * 0.7).rotated(rotation)
		velocity += side_thrust * delta
	
	# Вращение (Q/E)
	if Input.is_action_pressed("rotate_left"):
		angular_velocity -= rotation_speed * delta
	if Input.is_action_pressed("rotate_right"):
		angular_velocity += rotation_speed * delta

func apply_rotation(delta):
	rotation += angular_velocity * delta
	angular_velocity *= rotation_friction

func apply_external_forces():
	# Применяем гравитацию и другие внешние силы
	velocity += external_forces
	external_forces = Vector2.ZERO  # Сбрасываем после применения

func add_external_force(force: Vector2):
	# Этот метод будет вызываться планетой для добавления гравитации
	external_forces += force

func apply_friction():
	velocity *= friction

func limit_max_speed():
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
