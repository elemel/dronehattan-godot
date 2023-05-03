extends RigidBody3D

@export var mouse_sensitivity = deg_to_rad(0.05)
@export var max_acceleration = 20
@export var max_speed = 20

@export var camera_heading_angle = deg_to_rad(90)
@export var camera_pitch_angle = 0

@export var max_velocity_angle = deg_to_rad(22.5)
@export var max_acceleration_angle = deg_to_rad(22.5)

@onready var camera: Camera3D = $Camera3D


func _input(event):
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_heading_angle += event.relative.x * mouse_sensitivity
		camera_pitch_angle -= event.relative.y * mouse_sensitivity
		camera_pitch_angle = clamp(camera_pitch_angle, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	var move_direction = Vector3.ZERO

	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1

	if Input.is_action_pressed("move_right"):
		move_direction.x += 1

	if Input.is_action_pressed("move_forward"):
		move_direction.z -= 1

	if Input.is_action_pressed("move_back"):
		move_direction.z += 1

	move_direction.y = move_direction.z * -sin(camera_pitch_angle)
	move_direction.z *= cos(camera_pitch_angle)

	if move_direction != Vector3.ZERO:
		move_direction = move_direction.rotated(Vector3.UP, deg_to_rad(90) - camera_heading_angle)
		move_direction = move_direction.normalized()

	# rotation.x = move_direction.y * deg_to_rad(max_angle_x)
	# rotation.z = -move_direction.x * deg_to_rad(max_angle_z)
	# move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y)

	var previous_linear_velocity = Vector3(linear_velocity)
	linear_velocity = linear_velocity.move_toward(move_direction * max_speed, max_acceleration * delta)
	var acceleration = (linear_velocity - previous_linear_velocity) / delta

	var target_velocity_rotation = Vector2(linear_velocity.x, linear_velocity.z) * max_velocity_angle / max_speed
	var target_acceleration_rotation = Vector2(acceleration.x, acceleration.z) * max_acceleration_angle / max_acceleration

	var target_rotation_2d = target_velocity_rotation + target_acceleration_rotation
	target_rotation_2d = target_rotation_2d.rotated(rotation.y - deg_to_rad(90))
	var target_rotation = Vector3(target_rotation_2d.x, rotation.y, target_rotation_2d.y)
	# rotation = rotation.move_toward(target_rotation, delta * 10)

	# camera.rotation.y = camera_heading_angle
	var look_direction = Vector3(cos(camera_heading_angle), 0, sin(camera_heading_angle))
	camera.look_at(camera.global_position - look_direction, basis.y)
	camera.rotation.x = camera_pitch_angle

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_heading_angle = camera.global_rotation.y
