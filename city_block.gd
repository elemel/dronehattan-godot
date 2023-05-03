extends Node3D

const ALLEY_WIDTH = 30
const STREET_WIDTH = 18

var rng = RandomNumberGenerator.new()
# var size = Vector2(274, 80) - Vector2(30, 18)

@onready var volume: MeshInstance3D = $Volume

# Called when the node enters the scene tree for the first time.
func _ready():
	var volume_mesh: BoxMesh = volume.mesh
	var area_size = Vector2(volume_mesh.size.x, volume_mesh.size.z)
	var block_height = volume_mesh.size.y
	var buildable_size = area_size - Vector2(ALLEY_WIDTH, STREET_WIDTH)
	var stack = [Rect2(-0.5 * buildable_size, buildable_size)]

	while stack:
		var rect: Rect2 = stack.pop_back()

		if max(rect.size.x, rect.size.y) > 60:
			var split_fraction = rng.randf_range(0.4, 0.6)

			if rect.size.x > rect.size.y:
				var position_1 = Vector2(rect.position)
				var size_1 = Vector2(split_fraction * rect.size.x, rect.size.y)
				stack.push_back(Rect2(position_1, size_1))

				var position_2 = Vector2(rect.position.x + size_1.x, rect.position.y)
				var size_2 = Vector2(rect.size.x - size_1.x, rect.size.y)
				stack.push_back(Rect2(position_2, size_2))
			else:
				var position_1 = Vector2(rect.position)
				var size_1 = Vector2(rect.size.x, split_fraction * rect.size.y)
				stack.push_back(Rect2(position_1, size_1))

				var position_2 = Vector2(rect.position.x, rect.position.y + size_1.y)
				var size_2 = Vector2(rect.size.x, rect.size.y - size_1.y)
				stack.push_back(Rect2(position_2, size_2))
		else:
			var building_height = rng.randfn(block_height, 30)

			if building_height > 10:
				var mesh = BoxMesh.new()
				mesh.size = Vector3(rect.size.x, building_height, rect.size.y)

				var mesh_instance = MeshInstance3D.new()
				mesh_instance.mesh = mesh
				mesh_instance.position = Vector3(
					rect.position.x + 0.5 * rect.size.x,
					0.5 * building_height - 0.5 * block_height,
					rect.position.y + 0.5 * rect.size.y)

				var hue = rng.randfn(0.3, 0.05)
				var saturation = rng.randfn(0.2, 0.1)
				var lightness = rng.randfn(0.8, 0.1)
				var color = Color.from_ok_hsl(hue, saturation, lightness)

				var material = StandardMaterial3D.new()
				material.albedo_color = color
				mesh_instance.set_surface_override_material(0, material)

				add_child(mesh_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
