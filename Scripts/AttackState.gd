extends State

func enter():
    fsm.player.animated_sprite_2d.play("Attack")

func handle_input(event):
    pass

func update(delta):
    if fsm.player.animated_sprite_2d.animation_finished:
        fsm.change_state("IdleState")
