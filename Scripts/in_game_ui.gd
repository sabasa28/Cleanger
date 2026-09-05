extends Node

@export var timer_label : Label
@export var combo_timer_label : Label
@export var objective_label1 : RichTextLabel
@export var objective_label2 : RichTextLabel
@export var objective_label3 : RichTextLabel
@export var windows_label : RichTextLabel
@export var floors_label : RichTextLabel
@export var windows_rising_text_pool : RisingTextPool
@export var floors_rising_text_pool : RisingTextPool

func set_timer_text(time_left_num : int) -> void:
	timer_label.text = format_time(time_left_num)

func set_combo_timer_text(time_left_num : int) -> void:
	combo_timer_label.text = format_time(time_left_num)

func format_time(time_left_num : int) -> String:
	var mins = time_left_num / 60
	var secs = time_left_num % 60
	if secs < 10:
		secs = "0" + str(secs)
	return str(mins, ":", secs)

func update_minor_objective_text(objective_text1 : String, objective_text2 : String, objective_text3 : String) -> void:
	objective_label1.text = objective_text1
	objective_label2.text = objective_text2
	objective_label3.text = objective_text3

func update_mayor_objective_text(objective_text : String) -> void:
	objective_label1.text = ""
	objective_label2.text = objective_text
	objective_label3.text = ""

func cross_out_minor_objective(obj_num : int) -> void:
	match obj_num:
		0:
			objective_label1.text = "[i]" + objective_label1.text + "[/i]"#o se puede usar [s][/s]
		1:
			objective_label2.text = "[i]" + objective_label2.text + "[/i]"
		_:
			objective_label3.text = "[i]" + objective_label3.text + "[/i]"

func update_windows_label(new_windows_amount : float, windows_added : float) -> void:
	windows_label.text = str(new_windows_amount)
	windows_rising_text_pool.release_array_element(str(windows_added))

func update_floor_multiplier_label(new_floor_multiplier : float, multiplier_added : float) -> void:
	floors_label.text = str(new_floor_multiplier)
	floors_rising_text_pool.release_array_element(str(multiplier_added))

func reset_ui() -> void:
	windows_label.text = str(0)
	floors_label.text = str(1.0)
