extends "res://prop/talkingskull.gd"
@onready var EnemyScene = preload("res://skeleton/skullowpoly.tscn")
var used = false;
func _ready():
	pass
func use():
	if (!used):
		$TextBox.visible = true;
		label.text = ""
		get_tree().paused = true
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("Pause"):
		if ($TextBox.visible == true):
			get_tree().paused = false;
			$TextBox.visible = false;
	if Input.is_key_pressed(KEY_ENTER):
		if ($TextBox.visible == true):
			if (Input.is_key_pressed(KEY_ENTER)):
				if ($TextBox/LineEdit.text != "i"):
					$TextBox/LineEdit.text = ""
					var main = get_tree().current_scene
					var enemy_parent = main.get_node("Enemy")
					var enemy = EnemyScene.instantiate()

					enemy.position.x = -68.0 
					enemy.position.y = 0
					enemy.position.z = -42.0
					enemy.rotation.y = PI
			
					enemy_parent.add_child(enemy)
					enemy.orig = $"../../Enemy/orig6"
					enemy.enemyRange = $"../../Enemy/enemyRange6"
					enemy.label = label
					enemy.init()
					enemy.in_range = true;
				else:
					Connectable.unlock()
					Connectable.use()
					$CollisionShape3D.visible = false;
					used = true;
			get_tree().paused = false;
			$TextBox.visible = false;
