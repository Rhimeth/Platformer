extends CharacterBody2D

@export var speed = 400.0
@export var jump_speed = -800.0
@export var wall_jump_push = 100

# Gravity and jump strength
@export var gravity = 300

var is_attacking = false

	#movement and physics
func _physics_process(delta):
		# vertical movement velocity (down)
	velocity.y += gravity * delta
	# horizontal movement processing (left, right)
	horizontal_movement()
	#applies movement
	#move_and_slide() 
	
	#applies animations
	if !is_attacking:
		player_animations()
		
func _input(event):
	#on attack
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
	
func horizontal_movement():
	# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
	var horizontal_input = Input.get_action_strength("ui_right") -  Input.get_action_strength("ui_left")
	# horizontal velocity which moves player left or right based on input
	velocity.x = horizontal_input * speed

func player_animations():
	#on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")

	#on right (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")
		


func _on_sprite_2d_animation_finished():
	pass # Replace with function body.
