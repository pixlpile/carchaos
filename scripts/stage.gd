class_name Stage
extends Node3D

@export var available_tiles: Array[TileAttributes]
@export var cars_to_finish = 3
@export var next_level: PackedScene

@onready var buttons_container = %HFlowContainer
@onready var edit_group = $CanvasGroup
@onready var simulation_group = $SimulationGroup
@onready var next_button = %NextButton

var active_tile = 0
var finished_cars = 0

func _ready():
	edit_group.visible = true
	simulation_group.visible = false
	var buttons = buttons_container.get_children()
	var index = 0
	for button:Button in buttons:
		button.pressed.connect(set_active_tile.bind(index))
		if available_tiles[index].cost == 0:
			button.text = "€"
		else:
			button.text = str(available_tiles[index].cost)
		index += 1

func _unhandled_input(_event):
	if Input.is_action_just_pressed("selection_1"):
		set_active_tile(0)
		highlight_button(0)
	elif Input.is_action_just_pressed("selection_2"):
		set_active_tile(1)
		highlight_button(1)
	elif Input.is_action_just_pressed("selection_3"):
		set_active_tile(2)
		highlight_button(2)
		
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
	
	
func finish_car():
	finished_cars = finished_cars + 1
	if finished_cars == cars_to_finish:
		next_button.visible = true


func _on_button_pressed():
	finished_cars = 0
	next_button.visible = false
	edit_group.visible = false
	simulation_group.visible = true
	get_tree().call_group("spawner", "start_simulation")


func _on_retry_pressed():
	get_tree().call_group("spawner", "stop_simulation")
	get_tree().call_group("vehicle", "stop_simulation")
	finished_cars = 0
	simulation_group.visible = false
	next_button.visible = false
	edit_group.visible = true


func _on_next_level_pressed():
	get_tree().change_scene_to_packed(next_level)
