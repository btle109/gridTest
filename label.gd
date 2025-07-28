extends Label

func _process(_delta: float) -> void:
	$".".text = "LOC:"
	$".".text += str(round($"../../SubViewportContainer/SubViewport/char".global_transform.origin.x))
	$".".text += " "
	$".".text += str(round($"../../SubViewportContainer/SubViewport/char".global_transform.origin.z))
