extends CharacterBody3D
func spin(spinAmt, spinLen, walk)->void:
	get_parent().spin(spinAmt, spinLen, walk);
