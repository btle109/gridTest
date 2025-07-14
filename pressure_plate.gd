extends Node3D

@onready var weight := $weight
@onready var mesh := $MeshInstance3D
signal plateDown
signal plateUp

var original_position : Vector3
var pressed_position : Vector3
var is_down := false
var tween : Tween

const PUSH_DISTANCE := 0.01
const PUSH_TIME := 0.1

func _ready():
	original_position = mesh.transform.origin
	pressed_position = original_position - Vector3(0, PUSH_DISTANCE, 0)

func _physics_process(_delta):
	if weight.is_colliding() and not is_down:
		is_down = true
		start_tween(pressed_position)
		plateDown.emit()
	elif not weight.is_colliding() and is_down:
		is_down = false
		plateUp.emit()
		start_tween(original_position)

func start_tween(target_position: Vector3):
	if tween:
		tween.kill()  
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(mesh, "transform:origin", target_position, PUSH_TIME)
