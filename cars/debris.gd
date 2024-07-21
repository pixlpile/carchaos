extends Node3D

@onready var audio_streamer:AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	audio_streamer.play()

func _on_timer_timeout():
	queue_free()
