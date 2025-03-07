extends CharacterBody2D

const DEFAULT_GRAVITY = 1500.0
const DEFAULT_JUMP_SPEED = -500
const DEFAULT_WALK_SPEED = 300
const DASH_SPEED = 600
const CROUCH_WALK_SPEED = 150
const DEFAULT_SCALE = 1
const CROUCH_SCALE = 0.9  # 0.5
const CROUCH_OFFSET = 5.5  # 27.5
const DOUBLETAP_DELAY = 0.25

@export var gravity = DEFAULT_GRAVITY
@export var walk_speed = DEFAULT_WALK_SPEED
@export var jump_speed = DEFAULT_JUMP_SPEED
@onready var animplayer = $Animation

var can_double_jump: bool = true
var last_direction = ""
var is_crouching: bool = false
var landing: bool = false
var doubletap_time = DOUBLETAP_DELAY

func _get_input() -> void:
	if Input.is_action_pressed("move_crouch"):
		change_animation("crouch")
		walk_speed = CROUCH_WALK_SPEED
		if not is_crouching:
			get_node(".").scale.y = CROUCH_SCALE
			get_node(".").position.y += CROUCH_OFFSET
		is_crouching = true
	else:
		if is_crouching:
			change_animation("idle")
			get_node(".").position.y -= CROUCH_OFFSET
			get_node(".").scale.y = DEFAULT_SCALE
			walk_speed = DEFAULT_WALK_SPEED
		is_crouching = false

	if Input.is_action_just_pressed("move_left"):
		if last_direction == "left" and doubletap_time >= 0 and not is_crouching:
			walk_speed = DASH_SPEED
		else:
			walk_speed = DEFAULT_WALK_SPEED
			doubletap_time = DOUBLETAP_DELAY
		last_direction = "left"
	elif Input.is_action_just_pressed("move_right"):
		if last_direction == "right" and doubletap_time >= 0 and not is_crouching:
			walk_speed = DASH_SPEED
		else:
			walk_speed = DEFAULT_WALK_SPEED
			doubletap_time = DOUBLETAP_DELAY
		last_direction = "right"
		
func _determine_direction():
	if Input.is_action_pressed("move_left"):
		animplayer.flip_h = true
		velocity.x = -walk_speed
	elif Input.is_action_pressed("move_right"):
		animplayer.flip_h = false
		velocity.x = walk_speed
	else:
		velocity.x = 0
		
func _get_input_on_ground():
	if Input.is_action_just_pressed("move_jump"):
		velocity.y = jump_speed
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		change_animation("walk")
	else:
		change_animation("")

func _on_landing():
	change_animation("")
	can_double_jump = true
	landing = false
	
func _get_input_on_air():
	if Input.is_action_just_pressed("move_jump") and can_double_jump:
		velocity.y = jump_speed
		can_double_jump = false

func _on_jump():
	change_animation("jump")
	landing = true

func change_animation(state: String) -> void:
	if state == "":
		animplayer.play("idle")
		return
	animplayer.play(state)

func _physics_process(delta):
	velocity.y += delta * gravity

	# Handle all code interfacing with landing state
	if is_on_floor():
		_get_input_on_ground()
		if landing:
			_on_landing()
	else:
		_get_input_on_air()
		if !landing:
			_on_jump()

	# Regardless of air status (strafe, crouch)
	_get_input()
	_determine_direction()
	move_and_slide()

func _process(delta: float) -> void:
	doubletap_time -= delta
