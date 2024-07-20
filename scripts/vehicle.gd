class_name Vehicle
extends RigidBody3D

@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@export var speed = 1.0
@export var inverse_rotation: bool = true
@export var explosion : PackedScene
var target: Vector3
var current_waypoint: Vector3
var direction: Vector3
var skip = true
var have_set_target = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_target(vect):
	target = vect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if skip:
		skip = false
		return
	if have_set_target:
		print(target)
		navigation.target_position = target
		have_set_target = false
		return
		
	if navigation.is_target_reachable() && not navigation.is_navigation_finished():
		var next_pos = navigation.get_next_path_position()
		next_pos.y = position.y
		direction = (next_pos - position).normalized()
		if (next_pos != current_waypoint):
			current_waypoint = next_pos
			if inverse_rotation:
				var look_pos = -direction + position
				look_at(look_pos)
			else:
				look_at(next_pos)
			var magnitude = linear_velocity.length()
			linear_velocity = magnitude * direction
		apply_force(direction * speed * delta)
		
	if not navigation.is_target_reachable():
		print("Can't reach target")


func _on_body_entered(body):
	if body is Vehicle:
		var instance = explosion.instantiate() as Node3D
		instance.position = global_position
		instance.rotation = global_rotation
		get_tree().current_scene.add_child(instance)
		queue_free()
