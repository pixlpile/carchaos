class_name Vehicle
extends RigidBody3D

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@export var speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	navigation.target_position = Vector3(1.5,0,0.5);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if navigation.is_target_reachable() && not navigation.is_navigation_finished():
		var next_pos = navigation.get_next_path_position()
		next_pos.y = position.y
		look_at(next_pos)
		var direction = next_pos - position
		print(direction)
		apply_force(direction.normalized() * speed * delta)
