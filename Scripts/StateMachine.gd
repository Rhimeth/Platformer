extends Node

class_name StateMachine

var active : bool
var player: Node
var states = {}
var current_state: State

func _ready():
	player = get_parent()

func add_state(state_name: String, state: State):
	states[state_name] = state

func set_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states[new_state_name]
	if current_state:
		current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)

func handle_input(event):
	if current_state:
		current_state.handle_input(event)
