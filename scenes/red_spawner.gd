extends Node3D

@export var obj_path:PackedScene
@export var end_point:Node3D

func start_simulation():
	var loaded_scene = load(obj_path.resource_path)
	var world = get_parent_node_3d()
	var instance = loaded_scene.instantiate() as Vehicle
	instance.position = global_position
	instance.rotation = global_rotation
	instance.set_target(end_point.position)
	world.add_child(instance)
