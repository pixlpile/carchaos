extends Node3D

@onready var grid = $"../GridMap"
@onready var camera3d = $Camera3D
@onready var current_stage = $".."
@onready var money_label = %MoneyLabel

@export var money: int = 1000

func _ready():
	money_label.text = str(money) + " €"

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("place_tile"):
		var grid_local = get_grid_placement()
		if grid_local and grid.is_editable(grid_local):
			var id = current_stage.get_tile_id()
			var current_tile_id = grid.get_tile_id(grid_local)
			var current_tile_cost = current_stage.get_tile_cost_by_id(current_tile_id)
			if current_tile_id == id:
				var orientation = grid.get_cell_item_orientation(grid_local)
				var new_orientation = rotate_tile(id, orientation)
				grid.set_cell_item(grid_local, id, new_orientation)
			elif buy_tile(current_tile_cost):
				grid.set_cell_item(grid_local, id)
				money_label.text = str(money) + " €"
				print("money: " + str(money))

func rotate_tile(tile_id, orientation):
	var new_orientation = 0
	if tile_id == 0:
		if orientation == 0:
			new_orientation = 22
	elif tile_id == 6:
		if orientation == 0:
			new_orientation = 22
		if orientation == 22:
			new_orientation = 10
		if orientation == 10:
			new_orientation = 16
		if orientation == 16:
			new_orientation = 0
			
	elif tile_id == 7:
		if orientation == 0:
			new_orientation = 22
		if orientation == 22:
			new_orientation = 10
		if orientation == 10:
			new_orientation = 16
		if orientation == 16:
			new_orientation = 0
	return new_orientation
		

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

func buy_tile(current_tile_cost):
	var cost = current_stage.get_cost()
	if money + current_tile_cost >= cost:
		money += current_tile_cost-cost
		return true
	else: 
		return false
