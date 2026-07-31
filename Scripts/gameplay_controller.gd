extends Node2D

var timer_end : float
var current_timer : float = 0.0
var on_cleaning_phase : bool = false
var current_objective
@export var stage_spawner : Node2D
@export var run_time : float
@export var player : Player
@export var upgrades_ui : Node

func _ready() -> void:
	timer_end = run_time
	upgrades_ui.on_upgrades_finished.connect(start_cleaning_phase)
	start_cleaning_phase()

func start_cleaning_phase() -> void:
	upgrades_ui.visible = false
	on_cleaning_phase = true
	player.reset()
	current_timer = 0.0
	InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
	stage_spawner.reset_windows()

func end_cleaning_phase() -> void:
	on_cleaning_phase = false
	Stats.end_run()
	player.pause()
	upgrades_ui.visible = true

func _process(delta: float) -> void:
	if on_cleaning_phase:
		if current_timer >= timer_end:
			end_cleaning_phase()
		else:
			current_timer += delta
			InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
