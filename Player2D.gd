extends CharacterBody2D

# Exported variables for customization in the Godot editor
@export var SPEED = 110.0
@export var JUMP_SPEED = -350.0
@export var ACCELERATION = 800.0
@export var FRICTION = 800.0
@export var GRAVITY = 900.0
@export var AIR_RESISTANCE = 200.0
@export var AIR_ACCELERATION = 200.0
@export var JUMP_BUFFER_TIME = 0.1
@export var DASH_SPEED = 600.0
@export var DASH_DURATION = 0.25
@export var DASH_COOLDOWN = 5.0
@export var MAX_DASHES = 3

# State variables
var is_attacking = false
var double_jump = false
var jump_buffer_timer: float = 0.0
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_count: int = 0
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var frame_velocity = Vector2.ZERO
var grounded: bool = false
var _ended_jump_early: bool = false

# Reference to the animated sprite
@onready var animated_sprite_2d = $AnimatedSprite2D

# Function to initialize the character
func _ready():
	if not animated_sprite_2d.is_connected("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished")):
		animated_sprite_2d.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))

# Function to handle input events
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_attack") and not is_attacking:
			is_attacking = true
			animated_sprite_2d.play("Attack")

# Main physics processing function
func _physics_process(delta):
	apply_gravity(delta)
	handle_direction(delta)
	handle_gravity(delta)
	grounded = is_on_floor()
	frame_velocity = move_and_slide(frame_velocity)
	
	jump_buffer_timer -= delta
	dash_cooldown_timer -= delta

	if not is_attacking:
		update_animations()

	if Input.is_action_pressed("ui_attack") and is_attacking:
		if animated_sprite_2d.animation != "Attack":
			animated_sprite_2d.play("Attack")

	if Input.is_action_just_pressed("ui_dash") and dash_count < MAX_DASHES and dash_cooldown_timer <= 0:
		start_dash()

	update_dash(delta)
	handle_jump()
	handle_wall_jump()

# Apply gravity to the character
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

# Handle horizontal movement and apply acceleration or deceleration
func handle_direction(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 0:
		var deceleration = if grounded else AIR_RESISTANCE
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)

# Handle vertical movement and apply gravity
func handle_gravity(delta):
	if grounded and velocity.y <= 0.0:
		frame_velocity.y = 0.0

# Handle jump buffering and double jumps
func handle_jump():
	if is_on_floor():
		double_jump = true
		if Input.is_action_just_pressed("ui_jump"):
			frame_velocity.y = JUMP_SPEED
	else:
		if Input.is_action_just_pressed("ui_jump") and double_jump:
			frame_velocity.y = JUMP_SPEED
			double_jump = false

# Handle wall jumping
func handle_wall_jump():
	if not is_on_floor() and is_on_wall() and Input.is_action_just_pressed("ui_jump"):
		frame_velocity.y = JUMP_SPEED
		frame_velocity.x = -velocity.x * 0.5  # Jump away from the wall

# Start a dash
func start_dash():
	is_dashing = true
	dash_direction = Vector2(Input.get_axis("ui_left", "ui_right"), 0).normalized()
	dash_timer = DASH_DURATION
	dash_count += 1

# Update the dash state
func update_dash(delta):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			if dash_count >= MAX_DASHES:
				dash_cooldown_timer = DASH_COOLDOWN
				dash_count = 0
		else:
			frame_velocity = dash_direction * DASH_SPEED

# Update the character animations
func update_animations():
	if Input.is_action_pressed("ui_left"):
		animated_sprite_2d.flip_h = true
		if animated_sprite_2d.animation != "Run":
			animated_sprite_2d.play("Run")
	elif Input.is_action_pressed("ui_right"):
		animated_sprite_2d.flip_h = false
		if animated_sprite_2d.animation != "Run":
			animated_sprite_2d.play("Run")
	elif Input.is_action_pressed("ui_jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
		if animated_sprite_2d.animation != "Jump":
			animated_sprite_2d.play("Jump")
	else:
		if animated_sprite_2d.animation != "Idle":
			animated_sprite_2d.play("Idle")

# Handle animation finished event
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "Attack":
		is_attacking = false
		if is_on_floor():
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				animated_sprite_2d.play("Run")
			else:
				animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Jump")
