extends Node

@export var timer_label : Label
@export var objective_label1 : Label
@export var objective_label2 : Label
@export var objective_label3 : Label

func set_timer_text(time_left_num : int) -> void:
	var mins = time_left_num / 60
	var secs = time_left_num % 60
	if secs < 10:
		secs = "0" + str(secs)
	timer_label.text = str(mins, ":", secs)

func update_minor_objective_text(objective_text1 : String, objective_text2 : String, objective_text3 : String) -> void:
	objective_label1.text = objective_text1
	objective_label2.text = objective_text2
	objective_label3.text = objective_text3

func update_mayor_objective_text(objective_text : String) -> void:
	objective_label1.text = ""
	objective_label2.text = objective_text
	objective_label3.text = ""

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
