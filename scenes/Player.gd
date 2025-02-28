extends CharacterBody2D

@export var gravity = 1500.0
@export var walk_speed = 600
@export var jump_speed = -500

var can_double_jump = true
var can_dash = true
var last_direction = null
var isCrouching = false

func _physics_process(delta):
	velocity.y += delta * gravity
	
	if (is_on_floor() or can_double_jump) and Input.is_action_just_pressed('move_jump'):
		if not can_double_jump:
			print("double")
			can_double_jump = true
		elif (not is_on_floor() and can_double_jump):
			print("no double")
			can_double_jump = false
		get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_jump.png")
		velocity.y = jump_speed
	elif (is_on_floor()) and Input.is_action_pressed('move_crouch'):
		if not isCrouching:
			get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_duck.png")
			get_node(".").scale.y = 0.664
			get_node(".").position.y += 21
		isCrouching = true
		walk_speed = 400
	else:
		if isCrouching:
			get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_idle.png")
			get_node(".").scale.y = 1
			get_node(".").position.y -= 21
		isCrouching = false
		walk_speed = 800

	if Input.is_action_pressed("move_left"):
		if is_on_floor():
			get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_walk1.png")
		get_node("Sprite2D").flip_h = true
		velocity.x = -walk_speed
	elif Input.is_action_pressed("move_right"):
		if is_on_floor():
			get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_walk1.png")
		get_node("Sprite2D").flip_h = false
		velocity.x =  walk_speed
	else:
		if (is_on_floor() or can_double_jump):
			get_node("Sprite2D").texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_idle.png")
		velocity.x = 0

	# "move_and_slide" already takes delta time into account.
	move_and_slide()
	
func check_dash_trigger(direction):
	if can_dash and (direction == last_direction):
		print(direction)
		print("DASH!")
		can_dash = false
		walk_speed = 800
		can_dash = true
		walk_speed = 200
	last_direction = direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
