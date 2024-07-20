extends Node3D

@export var available_tiles: Array[TileAttributes]

@onready var buttons_container = $CanvasGroup/HFlowContainer
@onready var spawner = $red_spawner

var active_tile = 0

func _unhandled_input(_event):
	if Input.is_action_just_pressed("selection_1"):
		set_active_tile(0)
		highlight_button(0)
	elif Input.is_action_just_pressed("selection_2"):
		set_active_tile(1)
		highlight_button(1)
		
func get_cost():
	return available_tiles[active_tile].cost
	
func get_tile_id():
	return available_tiles[active_tile].id
	
func get_tile_cost_by_id(id):
	for tile in available_tiles:
		if tile.id == id:
			return tile.cost

func set_active_tile(id):
	active_tile = id
	highlight_button(id)
	

func highlight_button(id):
	var buttons = buttons_container.get_children()
	for button:Button in buttons:
		button.button_pressed  = false
	buttons[id].button_pressed = true


func _on_button_pressed():
	spawner.start_simulation()
