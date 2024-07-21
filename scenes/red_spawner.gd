extends Node3D

@export var cars_to_spawn: Array[PackedScene]
@export var end_point:Node3D
@onready var timer: Timer = $Timer
var index = 0

func _ready():
	add_to_group("spawner")

func start_simulation():
	index = 0
	spawn_car()


func spawn_car():
	var obj_path = cars_to_spawn[index]
	var loaded_scene = load(obj_path.resource_path)
	var world = get_parent_node_3d()
	var instance = loaded_scene.instantiate() as Vehicle
	instance.position = global_position
	instance.rotation = global_rotation
	instance.set_target(end_point.position)
	world.add_child(instance)
	index = index + 1
	if (index < cars_to_spawn.size()):
		timer.start()



func _on_timer_timeout():
	spawn_car()


func stop_simulation():
	timer.stop()
