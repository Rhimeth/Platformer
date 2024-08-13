extends State

var fsm: StateMachine

func enter():
	fsm.player.animated_sprite_2d.play("Idle")

func update(delta):
	if fsm.player.detect_player():
		fsm.change_state("ChaseState")
