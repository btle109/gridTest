extends Area3D
@export var label : Label

func use() -> void:
	label.text = "Empty stone coffins."
	label.reset()
