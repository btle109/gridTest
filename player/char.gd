extends Node3D

const TRAVEL_TIME := 0.3

@onready var front_ray := $CharacterBody3D/frontRay
@onready var back_ray := $CharacterBody3D/backRay
@onready var left_ray := $CharacterBody3D/leftRay
@onready var right_ray := $CharacterBody3D/rightRay
@onready var animation := $animation
@export var enemy: CharacterBody3D = null
@export var label : Label
var walkForward = false;
var DEF_CHANCE = 45
var ATK_CHANCE = 60
var atk_dmg = 10
var alive = true;
var HP = 100
var dirVec := Vector2.ZERO
var dragging := false
var swing_ready := true
const SWING_THRESHOLD := 40 
var tween : Tween
var in_range = false

var sound = preload("res://sound/sound2.mp3")

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
	if(!in_range):
		sound = load("res://sound/sound2.mp3")
		$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()
	dirVec = Vector2.ZERO
		
func _physics_process(_delta):
	if (HP <= 0 and alive):
		alive = false;
		die()

	if tween is Tween:
		if tween.is_running():
			return
		if animation.is_playing() and (animation.current_animation == "swing left" or animation.current_animation == "swing right" or animation.current_animation == "swing down" or animation.current_animation == "swing up"):
			return

	if Input.is_action_pressed("forward") and not front_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), TRAVEL_TIME)
		animation.play("bob")
		print(round(global_position.x), " ", round(global_position.z));
		
	if Input.is_action_pressed("back") and not back_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.BACK * 2), TRAVEL_TIME)
		animation.play("bob")
		print(round(global_position.x), " ", round(global_position.z));

	if Input.is_action_pressed("left") and not left_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.LEFT * 2), TRAVEL_TIME)
		animation.play("bob")
		print(round(global_position.x), " ", round(global_position.z));
	
	if Input.is_action_pressed("right") and not right_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.RIGHT * 2), TRAVEL_TIME)
		animation.play("bob")
		print(round(global_position.x), " ", round(global_position.z));
	
	if Input.is_action_pressed("turnLeft"):
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, PI / 2), TRAVEL_TIME)
		
	if Input.is_action_pressed("turnRight"):
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, -PI / 2), TRAVEL_TIME)
	
	if walkForward and not front_ray.is_colliding():
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.FORWARD * 2), TRAVEL_TIME)
		animation.play("bob")
		print(round(global_position.x), " ", round(global_position.z));
		walkForward = false;
func hurt(dmg) -> void:
	var prob = randi()%100 + 1
	var hitsound
	if (prob < DEF_CHANCE):
		hitsound = load("res://sound/swordclashshort.mp3")
		$hitsounds.stop()
		$hitsounds.stream = hitsound
		$hitsounds.play()
		HP -= 0.4 * dmg + randi()%4
		print("PLAYER ", HP, "ENEMY ATTACK DEFENDED")
	else:
		hitsound = load("res://sound/sound.wav")
		$hitsounds.stream = hitsound
		$hitsounds.play()
		HP -= dmg + randi()%7
		print("PLAYER ", HP, " ENEMY ATTACK SUCCESS")
		$hurt.play("playeranim/hurt")
		#screen blur/red/shake


func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		var prob = randi()%100 + 1
		if (prob < ATK_CHANCE):
			sound = load("res://sound/smashsound.mp3")
			body.hurt(atk_dmg)
		else:
			sound = load("res://sound/sound2.mp3")
		$AudioStreamPlayer.stream = sound
		$AudioStreamPlayer.play()
		in_range = true

func _on_attack_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		in_range = false

func die()->void:
		$hurt.play("playeranim/death")
		var hitsound = load("res://sound/sound.wav")
		$hitsounds.stream = hitsound
		$hitsounds.play()
		set_process_input(false)
		$deathTimer.start()
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.DOWN * 0.125), 1)
func _on_death_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/death.tscn")	
	
func spin(spinAmt, spinLen, walk) -> void:
	set_process_input(false)
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT);
	tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, spinAmt), spinLen);
	set_process_input(true)
	walkForward = walk;
	
