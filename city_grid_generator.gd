extends Node3D

const BLOCK_SIZE = Vector2(274, 80)

var city_block_generator_scene = preload("res://city_block_generator.tscn")

@onready var mesh_instance = $MeshInstance3D


func _ready():
	var mesh: PlaneMesh = mesh_instance.mesh

	var block_count_x = floori(mesh.size.x / BLOCK_SIZE.x)
	var block_count_y = floori(mesh.size.y / BLOCK_SIZE.y)

	for block_index_x in range(block_count_x):
		for block_index_y in range(block_count_y):
			var block_x = (block_index_x - 0.5 * (block_count_x - 1)) * BLOCK_SIZE.x
			var block_y = (block_index_y - 0.5 * (block_count_y - 1)) * BLOCK_SIZE.y

			var city_block_generator = city_block_generator_scene.instantiate()
			city_block_generator.position = Vector3(block_x, 0, block_y)
			add_child(city_block_generator)


func _process(delta):
	pass
