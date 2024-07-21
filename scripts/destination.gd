extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Vehicle:
		body.queue_free()
		var stage = get_tree().current_scene as Stage
		stage.finish_car()
