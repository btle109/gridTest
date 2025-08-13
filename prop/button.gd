extends Node3D
@export var Connectable = Area3D
func use():
	$"AnimationPlayer".play("push")
	#if (Connectable.has_method("unlock")):
	Connectable.unlock()
	Connectable.use()
