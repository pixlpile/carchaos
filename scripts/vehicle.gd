class_name Vehicle
extends RigidBody3D

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@export var speed = 1.0
var target: Vector3
var current_waypoint: Vector3
var direction: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_target(vect):
	target = vect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	navigation.target_position = target
	if navigation.is_target_reachable() && not navigation.is_navigation_finished():
		var next_pos = navigation.get_next_path_position()
		next_pos.y = position.y
		direction = (next_pos - position).normalized()
		if (next_pos != current_waypoint):
			current_waypoint = next_pos
			look_at(next_pos)
			var magnitude = linear_velocity.length()
			linear_velocity = magnitude * direction
		#linear_velocity = direction
		apply_force(direction * speed * delta)
	if not navigation.is_target_reachable():
		print("Can't reach target")
