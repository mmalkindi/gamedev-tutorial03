extends CharacterBody2D

const DEFAULT_GRAVITY = 1500.0
const DEFAULT_JUMP_SPEED = -500
const DEFAULT_WALK_SPEED = 300
const DASH_SPEED = 600
const CROUCH_WALK_SPEED = 50
const DEFAULT_SIZE = 1
const DEFAULT_OFFSET = 0
const CROUCH_SIZE = 1 # 0.5
const CROUCH_OFFSET = 0 # 27.5
const DOUBLETAP_DELAY = .25

@export var gravity = DEFAULT_GRAVITY
@export var walk_speed = DEFAULT_WALK_SPEED
@export var jump_speed = DEFAULT_JUMP_SPEED

var can_double_jump = true
var can_dash = true
var last_direction = ""
var direction = 0
var is_crouching = false
var landing : bool
var doubletap_time = DOUBLETAP_DELAY

func _physics_process(delta):
	velocity.y += delta * gravity # Always apply gravity
	
	# Handle all code interfacing with landing state
	if is_on_floor():
		# on ground
		if Input.is_action_just_pressed('move_jump'):
			velocity.y = jump_speed
		elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			change_sprite("walk")
		else:
			change_sprite("")
		
		if landing:
			# just landed
			change_sprite("")
			can_double_jump = true
			landing = false
	else: 
		# in the air
		if Input.is_action_just_pressed('move_jump') and can_double_jump:
			velocity.y = jump_speed
			can_double_jump = false
		
		if !landing:
			# takeoff
			change_sprite("jump")
			landing = true
	
	# Regardless of air status (strafe, crouch)
	if Input.is_action_pressed('move_crouch'):
		change_sprite("crouch")
		walk_speed = CROUCH_WALK_SPEED
		if not is_crouching:
			get_node(".").scale.y = CROUCH_SIZE
			get_node(".").position.y += CROUCH_OFFSET
		is_crouching = true
	else:
		if is_crouching:
			change_sprite("")
			get_node(".").position.y -= CROUCH_OFFSET
			get_node(".").scale.y = DEFAULT_SIZE
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
		
	# Determine direction
	if Input.is_action_pressed("move_left"):
		get_node("Sprite2D").flip_h = true
		velocity.x = -walk_speed
	elif Input.is_action_pressed("move_right"):
		get_node("Sprite2D").flip_h = false
		velocity.x = walk_speed
	else:
		velocity.x = 0
		
	# "move_and_slide" already takes delta time into account.
	move_and_slide()

func change_sprite(state: String) -> void:
	if state == "jump":
		get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_jump.png")
	elif state == "walk":
		get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_walk1.png")
	elif state == "crouch":
		get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_duck.png")
	else:
		get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_stand.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	doubletap_time -= delta
