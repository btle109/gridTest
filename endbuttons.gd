extends "res://scenes/menuscript.gd"
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")	
