extends Area3D

func _on_area_3d_button() -> void:
	$Block2.visible = false
	$CollisionShape3D.disabled = true
