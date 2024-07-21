class_name Vehicle
extends RigidBody3D

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@export var speed = 1.0
@export var inverse_rotation: bool = true
@export var explosion : PackedScene
var target: Vector3
var current_waypoint: Vector3
var current_angle: float
var direction: Vector3
var skip = true
var have_set_target = true

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("vehicle")
	direction = (global_transform.basis * Vector3.FORWARD)


func set_target(vect):
	target = vect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if skip:
		skip = false
		return
	if have_set_target:
		navigation.target_position = target
		have_set_target = false
		return
		
	if navigation.is_target_reachable() && not navigation.is_navigation_finished():
		var next_pos = navigation.get_next_path_position()
		if (next_pos != current_waypoint):
			current_waypoint = next_pos
			var angle = Quaternion(direction, global_position.direction_to(current_waypoint)).get_euler().y
			direction = global_position.direction_to(current_waypoint)
			if absf(current_angle - angle) > .1:
				current_angle = angle
				if inverse_rotation:
					look_at(-direction + position)
				else:
					look_at(next_pos)
				var magnitude = linear_velocity.length()
				linear_velocity = magnitude * direction
	apply_force(direction * speed * delta)
		
	if not navigation.is_target_reachable():
		speed = 0


func stop_simulation():
	queue_free()


func _on_body_entered(body):
	if body is Vehicle:
		var instance = explosion.instantiate() as Node3D
		instance.position = global_position
		instance.rotation = global_rotation
		get_tree().current_scene.add_child(instance)
		queue_free()
