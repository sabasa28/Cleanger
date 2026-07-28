extends Node2D

var timer_end : float
var current_timer : float = 0.0
var on_cleaning_phase : bool = false
var current_objective


func _ready() -> void:
	timer_end = 75.0
	start_cleaning_phase()

func start_cleaning_phase() -> void:
	on_cleaning_phase = true
	current_timer = 0.0
	InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?

func end_cleaning_phase() -> void:
	on_cleaning_phase = false

func _process(delta: float) -> void:
	if on_cleaning_phase:
		if current_timer >= timer_end:
			end_cleaning_phase()
		else:
			current_timer += delta
			InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
