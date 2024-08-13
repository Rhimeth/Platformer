extends CharacterBody2D

@export var speed = 100
@export var detection_radius = 200

var fsm: StateMachine
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	fsm = StateMachine.new(self)
	fsm.add_state("IdleState", preload("res://Scripts/EnemyIdleState.gd").new())
	fsm.add_state("ChaseState", preload("res://Scripts/EnemyChaseState.gd").new())
	fsm.change_state("IdleState")

func _physics_process(delta):
	fsm.update(delta)
	move_and_slide()

func detect_player():
	var player = get_parent().get_node("Player")
	return (player.global_position - global_position).length() < detection_radius
