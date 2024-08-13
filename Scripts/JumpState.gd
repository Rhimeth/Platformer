extends State

func enter():
    fsm.player.animated_sprite_2d.play("Jump")
    fsm.player.velocity.y = fsm.player.JUMP_SPEED

func handle_input(event):
    pass

func update(delta):
    fsm.player.apply_gravity(delta)
    if fsm.player.is_on_floor():
        fsm.change_state("IdleState")
