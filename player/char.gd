extends Node3D

const TRAVEL_TIME := 0.3

@onready var front_ray := $CharacterBody3D/frontRay
@onready var back_ray := $CharacterBody3D/backRay
@onready var left_ray := $CharacterBody3D/leftRay
@onready var right_ray := $CharacterBody3D/rightRay
@onready var animation := $animation
var dirVec := Vector2.ZERO
var dragging := false
var swing_ready := true
const SWING_THRESHOLD := 40 
var tween : Tween

func snap_to_grid(pos: Vector3, grid_size: float = 2.0) -> Vector3:
	return Vector3(
		round(pos.x / grid_size) * grid_size,
		round(pos.y),
		round(pos.z / grid_size)
	)
	
func _ready():
	transform.origin = snap_to_grid(transform.origin)

func _input(event):
	if event is InputEventMouseButton and Input.is_action_pressed("RMB"):
		if event.pressed:
			dragging = true
			dirVec = Vector2.ZERO
			swing_ready = true
		else:
			dragging = false
			swing_ready = true
			dirVec = Vector2.ZERO

	elif event is InputEventMouseMotion and dragging:
		dirVec += event.relative
		if dirVec.length() >= SWING_THRESHOLD and swing_ready:
			process_swing()

func process_swing():
	if animation.is_playing() and (animation.current_animation == "swing left" or animation.current_animation == "swing right" or animation.current_animation == "swing down" or animation.current_animation == "swing up"):
		return
	swing_ready = false  # Prevent re-trigger until next swing
	var direction = dirVec.normalized()
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animation.play("swing right")
		else:
			animation.play("swing left")
	else:
		if direction.y > 0:
			animation.play("swing down")
		else:
			animation.play("swing up")
	dirVec = Vector2.ZERO


func _physics_process(_delta):
	if tween is Tween:
		if tween.is_running():
			return
		if animation.is_playing() and (animation.current_animation == "swing left" or animation.current_animation == "swing right" or animation.current_animation == "swing down" or animation.current_animation == "swing up"):
			return
	#if right_ray.is_colliding():
	#	var collider = right_ray.get_collider()
	#	print("Right Hit object: ", collider.name)
	if Input.is_action_pressed("forward") and not front_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), TRAVEL_TIME)
		animation.play("bob")
		
	if Input.is_action_pressed("back") and not back_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.BACK * 2), TRAVEL_TIME)
		animation.play("bob")
		
	if Input.is_action_pressed("left") and not left_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.LEFT * 2), TRAVEL_TIME)
		animation.play("bob")
		
	if Input.is_action_pressed("right") and not right_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.RIGHT * 2), TRAVEL_TIME)
		animation.play("bob")
		
	if Input.is_action_pressed("turnLeft"):
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, PI / 2), TRAVEL_TIME)
		
	if Input.is_action_pressed("turnRight"):
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, -PI / 2), TRAVEL_TIME)
