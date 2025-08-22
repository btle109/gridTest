extends "res://prop/hp_statue.gd"
@export var atk = false;
@export var def = false;
var used = false;

func use() -> void:
	if (!used):
		if (def):
			player.DEF_CHANCE += 6
			label.text = "You feel tougher than before."
		if (atk):
			player.ATK_CHANCE += 6
			label.text = "You feel stronger than before."
		used = true;
		$AudioStreamPlayer3D.play()
	else:
		label.text = "You feel nothing."
	label.reset()
