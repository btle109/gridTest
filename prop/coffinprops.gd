extends Area3D
@export var label : Label
@export var text = "Empty stone coffins."
func use() -> void:
	label.text = text
	label.reset()
