extends Node3D
signal button

func use():
	$"../AnimationPlayer".play("push")
	button.emit()
