extends "res://prop/door.gd"
@export var locked = true
func unlock() -> void:
	locked = false
func use() -> void:
	if (!locked):
		if (!up):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "transform", transform.translated_local(Vector3.UP * 3.75), 2.25)
			$doorSound.stream = door
			$doorSound.play()
			up = true
