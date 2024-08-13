extends State

var fsm: StateMachine

func enter():
	fsm.player.animated_sprite_2d.play("Run")

func update(delta):
	var player = fsm.player.get_parent().get_node("Player")
	var direction = (player.global_position - fsm.player.global_position).normalized()
	fsm.player.velocity = direction * fsm.player.speed

	if (player.global_position - fsm.player.global_position).length() < 50:
		fsm.change_state("AttackState")
	elif not fsm.player.detect_player():
		fsm.change_state("IdleState")
