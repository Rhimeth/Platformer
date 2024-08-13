extends State

var dash_time_remaining: float

var fsm: StateMachine

func enter():
	fsm.player.animated_sprite_2d.play("Dash")
	dash_time_remaining = fsm.player.dash_duration
	fsm.player.dash_direction = Vector2(Input.get_axis("ui_left", "ui_right"), 0).normalized()
	fsm.player.velocity = fsm.player.dash_direction * fsm.player.dash_speed
	fsm.player.dash_count += 1

func update(delta):
	dash_time_remaining -= delta
	if dash_time_remaining <= 0:
		fsm.change_state("IdleState")
	else:
		fsm.player.velocity = fsm.player.dash_direction * fsm.player.dash_speed

func handle_input(event):
	pass  # No input handling during dash
