extends RigidBody3D

@export var mouse_sensitivity = deg_to_rad(0.05)
@export var acceleration = 20
@export var max_speed = 20

@export var camera_heading_angle = deg_to_rad(90)
@export var camera_pitch_angle = 0

@export var max_angle_x = deg_to_rad(22.5)
@export var max_angle_z = deg_to_rad(22.5)

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

	linear_velocity = linear_velocity.move_toward(move_direction * max_speed, acceleration * delta)

	# camera.rotation.y = camera_heading_angle
	var look_direction = Vector3(cos(camera_heading_angle), 0, sin(camera_heading_angle))
	camera.look_at(camera.global_position - look_direction)
	camera.rotation.x = camera_pitch_angle

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
