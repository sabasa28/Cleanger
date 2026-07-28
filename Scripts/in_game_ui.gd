extends Node

@export var timer_label : Label
@export var objective_label : Label

func set_timer_text(time_left_num : int) -> void:
	var mins = time_left_num / 60
	var secs = time_left_num % 60
	if secs < 10:
		secs = "0" + str(secs)
	timer_label.text = str(mins, ":", secs)

func update_objective_text(objective_text : String) -> void:
	objective_label.text = objective_text

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
