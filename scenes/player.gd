extends Node3D

@onready var grid = $"../GridMap" 

var meshes

func _ready():
	meshes = grid.get_used_cells()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("place_tile"):
		var mouse_pos = get_viewport().get_mouse_position() 
		print(mouse_pos)
		var camera3d = $"../Camera3D"
		var origin = camera3d.project_ray_origin(mouse_pos)
		var end = origin + camera3d.project_ray_normal(mouse_pos) * 1000
		
		var space = get_world_3d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters3D.create(origin, end)
		rayQuery.exclude = [self]
		var result = space.intersect_ray(rayQuery)
		
		if result.size()>1:
			print(result.position)
			var grid_local = result.position
			if grid_local.x < 0:
				grid_local.x = floor(grid_local.x)
			if grid_local.z < 0:
				grid_local.z = floor(grid_local.z)
			print(grid_local)
			var cell_item = grid.get_cell_item(grid_local)
			if cell_item == 1:
				grid.set_cell_item(grid_local, 0)
