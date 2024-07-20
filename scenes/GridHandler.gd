extends GridMap

var illegal_cells = []

func _ready():
	get_free_cells()
	
func get_free_cells():
	var all_cells = get_used_cells()
	for cell in all_cells:
		var item = get_cell_item(cell)
		if item != 1:
			illegal_cells.append(cell)

func is_editable(placement:Vector3i):
	if placement in illegal_cells:
		return false
	return true
