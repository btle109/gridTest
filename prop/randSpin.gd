extends "res://prop/spinnerTile.gd"

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("spinning")
	var rand = randi()%2
	if (rand == 1):
		spinAmt *= -1;
	rand = randi()%2
	if (rand == 0):
		walk = false;
	else:
		walk = true
	if(body.has_method("spin")):
		body.spin(spinAmt, spinLen, walk)
