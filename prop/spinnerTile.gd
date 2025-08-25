extends Node3D
@export var spinAmt = 0.0;
@export var spinLen = 0.5
@export var walk = true;
func _on_area_3d_body_entered(body: Node3D) -> void:
	print("spinning")
	if(body.has_method("spin")):
		body.spin(spinAmt, spinLen, walk)
	
