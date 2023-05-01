extends RigidBody3D

@export var mouse_sensitivity = 0.1

@onready var camera: Camera3D = $Camera3D


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_ESCAPE:
			if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var movement = event.relative
		camera.rotation.x -= deg_to_rad(movement.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.y += -deg_to_rad(movement.x * mouse_sensitivity)


func _process(delta):
	pass

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
