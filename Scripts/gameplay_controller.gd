class_name GameplayController

extends Node2D

var timer_end : float
var current_timer : float = 0.0
var combo_timer : float = 0.0
var running_combo_timer : bool = false
var on_cleaning_phase : bool = false
var current_objective
@export var stage_spawner : Node2D
@export var run_time : float
@export var player : Player
@export var upgrades_ui : Node

func _ready() -> void:
	Stats.gameplay_controller = self
	timer_end = run_time
	upgrades_ui.on_upgrades_finished.connect(start_cleaning_phase)
	start_cleaning_phase()

func start_cleaning_phase() -> void:
	upgrades_ui.visible = false
	on_cleaning_phase = true
	player.reset()
	current_timer = 0.0
	InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
	stop_combo_timer()
	stage_spawner.reset_windows()
	Stats.start_run()

func end_cleaning_phase() -> void:
	Stats.on_combo_finished()
	on_cleaning_phase = false
	Stats.end_run()
	player.pause()
	stop_combo_timer()
	upgrades_ui.prepare_and_set_visible()

func _process(delta: float) -> void:
	if on_cleaning_phase:
		if current_timer >= timer_end:
			end_cleaning_phase()
		else:
			current_timer += delta
			InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
		if running_combo_timer:
			combo_timer -= delta
			if combo_timer <= 0.0:
				combo_timer = 0.0
				running_combo_timer = false
				Stats.on_combo_finished()
			InGameUi.set_combo_timer_text((int)(combo_timer))

func set_combo_timer(new_time : float) -> void:
	running_combo_timer = true
	combo_timer = new_time

func stop_combo_timer() -> void:
	running_combo_timer = false
	combo_timer = 0.0
	InGameUi.set_combo_timer_text((int)(combo_timer))
