extends Node3D

@export var Connectable = Area3D
var down = false
var tween : Tween

func use():
	if(!down):
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.DOWN * 0.25), 0.25)
		#if (Connectable.has_method("unlock")):
		Connectable.unlock()
		Connectable.use()
		down = true;
