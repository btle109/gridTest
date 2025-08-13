extends Label
var player: Node3D = get_parent();
func _process(_delta: float) -> void:
	$".".text = "LOC:"
	$".".text += str(round(player.global_position.x))
	$".".text += " "
	$".".text += str(round(player.global_position.z))
