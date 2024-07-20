extends Node3D

@onready var grid = $"../GridMap"
@onready var camera3d = $Camera3D

@export var money: int = 1000

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("place_tile"):
		var grid_local = get_grid_placement()
		if grid_local and grid.is_editable(grid_local):
			if buy_tile(300):
				grid.set_cell_item(grid_local, 0)
	
	if Input.is_action_just_pressed("remove_tile"):
		var grid_local = get_grid_placement()
		if grid_local and grid.is_editable(grid_local):
			if buy_tile(-300):
				grid.set_cell_item(grid_local, 1)

func get_grid_placement():
	var mouse_pos = get_viewport().get_mouse_position() 
	var origin = camera3d.project_ray_origin(mouse_pos)
	var end = origin + camera3d.project_ray_normal(mouse_pos) * 1000
		
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.create(origin, end)
	rayQuery.exclude = [self]
	var result = space.intersect_ray(rayQuery)
	if result.size()>1:
		var grid_local = result.position
		if grid_local.x < 0:
			grid_local.x = floor(grid_local.x)
		if grid_local.z < 0:
			grid_local.z = floor(grid_local.z)
		return grid_local
	return false

func buy_tile(cost):
	if money > cost:
		money += -cost
		return true
	else: 
		return false
