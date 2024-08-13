extends State

var fsm: StateMachine

func enter():
	fsm.player.animated_sprite_2d.play("Run")

func handle_input(event):
	if Input.is_action_just_pressed("ui_jump"):
		fsm.change_state("JumpState")
	elif not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		fsm.change_state("IdleState")
	elif Input.is_action_just_pressed("ui_attack"):
		fsm.change_state("AttackState")
	elif Input.is_action_just_pressed("ui_dash"):
		fsm.change_state("DashState")

func update(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	fsm.player.velocity.x = direction * fsm.player.SPEED
