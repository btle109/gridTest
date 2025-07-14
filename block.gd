extends MeshInstance3D


func _on_pressure_plate_plate_down() -> void:
	visible = false

func _on_pressure_plate_plate_up() -> void:
	visible = true
