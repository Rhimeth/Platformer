extends CharacterBody2D

@export var speed = 150
@export var gravity = 980
@export var jump_height = -300
@export var acceleration = 800.0

var jump_buffer_timer: float = 0.0
var is_attacking = false
var double_jump = false



func _physics_process(delta):
	velocity.y += gravity * delta
	movement()
	move_and_slide()
	player_animations()
	handle_jump()
	
	if !is_attacking:
		player_animations()
	
func _process(delta):
	pass

func movement():
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# horizontal velocity which moves player left or right based on input
	velocity.x = horizontal_input * speed
	
func player_animations():
	if is_attacking:
		$AnimatedSprite2D.play("Attack")
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("Run")
		$AnimatedSprite2D.flip_h = Input.is_action_pressed("ui_left")
	elif Input.is_action_pressed("ui_jump"):
		if $AnimatedSprite2D.animation != "Jump":
			$AnimatedSprite2D.play("Jump")
	else:
		$AnimatedSprite2D.play("Idle")
		
func handle_jump():
	if is_on_floor():
		double_jump = true
		if Input.is_action_just_pressed("ui_jump"):
			velocity.y = jump_height
	else:
		if Input.is_action_just_pressed("ui_jump") and double_jump:
			velocity.y = jump_height
			double_jump = false

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
