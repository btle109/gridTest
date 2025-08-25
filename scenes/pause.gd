extends Node
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Reset"):
		if (get_tree().paused == false):
			get_tree().reload_current_scene()
		else:
			get_tree().quit()
	if event.is_action_pressed("Pause"):
		if (get_tree().paused == true):
			get_tree().paused = false
			$"../SubViewportContainer/Info".text = ""
			print("game unpause")
		else:
			get_tree().paused = true
			$"../SubViewportContainer/Info".text = "Game paused."
			print("game pause")
