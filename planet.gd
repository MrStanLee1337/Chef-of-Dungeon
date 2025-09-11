extends Node2D

@export var gravity_strength : float = 1000.0
@export var planet_mass : float = 1000.0
@export var max_gravity_distance : float = 2000.0

func _ready():
	# Настраиваем радиус гравитационного поля
	var gravity_collision = $GravityField/CollisionShape2D
	if gravity_collision and gravity_collision.shape is CircleShape2D:
		gravity_collision.shape.radius = max_gravity_distance

func _on_gravity_field_body_entered(body):
	if body is CharacterBody2D and body.has_method("add_external_force"):
		# Начинаем обрабатывать гравитацию для этого тела
		set_physics_process(true)

func _on_gravity_field_body_exited(body):
	if body is CharacterBody2D:
		# Проверяем, остались ли другие тела в зоне гравитации
		var overlapping_bodies = $GravityField.get_overlapping_bodies()
		var has_spaceships = false
		
		for b in overlapping_bodies:
			if b is CharacterBody2D and b.has_method("add_external_force"):
				has_spaceships = true
				break
		
		if not has_spaceships:
			set_physics_process(false)

func _physics_process(delta):
	# Применяем гравитацию ко всем кораблям в зоне
	for body in $GravityField.get_overlapping_bodies():
		if body is CharacterBody2D and body.has_method("add_external_force"):
			apply_gravity_to_body(body, delta)

func apply_gravity_to_body(body, delta):
	var direction_to_planet = global_position - body.global_position
	var distance_squared = direction_to_planet.length_squared()
	
	# Проверка максимальной дистанции
	if distance_squared > max_gravity_distance * max_gravity_distance:
		return
	
	# Избегаем деления на ноль
	if distance_squared < 1.0:
		return
	
	# Вычисляем силу гравитации (F = G * m1 * m2 / r^2)
	var force = (gravity_strength * planet_mass) / distance_squared
	
	# Применяем силу (умножаем на delta для frame rate independence)
	var gravity_force = direction_to_planet.normalized() * force * delta
	
	# Передаем силу кораблю
	body.add_external_force(gravity_force)
