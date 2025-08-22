extends Node3D
@export var Connectable = Area3D
var flipped = false;
func use():
	if (!flipped):
		$"AnimationPlayer".play("pull1")
		Connectable.unlock()
		flipped = true;
	else:
		$"AnimationPlayer".play("pull2")
		Connectable.lock()
		flipped = false;
	$"AudioStreamPlayer3D".play()
