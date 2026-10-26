extends Node

@export var timer_label : Label
@export var combo_amount_label : Label
@export var combo_timer_label : Label
@export var combo_circular_timer : TextureProgressBar
@export var combo_timer_base_color : Color
@export var combo_timer_half_color : Color
@export var combo_timer_low_color : Color
@export var combo_timer_stoped_color : Color
@export var objective_label1 : RichTextLabel
@export var objective_label2 : RichTextLabel
@export var objective_label3 : RichTextLabel
@export var windows_label : RichTextLabel
@export var floors_label : RichTextLabel
@export var final_windows_label : Label
@export var final_spots_label : Label
@export var final_floor_label : Label
@export var final_combo_label : Label
@export var final_coins_label : Label
@export var windows_rising_text_pool : RisingTextPool
@export var floors_rising_text_pool : RisingTextPool
@export var end_stats_panel : Control
@export var end_day_button : Button
@export var end_day_button_grace_period : float
var end_day_button_timer : float = 0.0
signal on_day_end
@export var combo_ui : Control
@export var floors_ui : Control

func _ready() -> void:
	final_floor_label.text = ""
	final_combo_label.text = ""
	end_stats_panel.visible = false
	display_combo(false)
	display_floors(false)

func _process(delta: float) -> void:
	if end_day_button.disabled:
		end_day_button_timer += delta
		if end_day_button_timer >= end_day_button_grace_period:
			end_day_button.disabled = false
			end_day_button_timer = 0.0

func set_timer_text(time_left_num : int) -> void:
	timer_label.text = format_time(time_left_num)

func set_combo_timer_text(time_left_num : int, time_left_ooo : float) -> void: #ooo = out of one
	if time_left_ooo == 0.0:
		combo_timer_label.text = ""
	else:
		combo_timer_label.text = format_time(time_left_num)
	
	if time_left_ooo == 0.0:
		combo_circular_timer.value = 1.0
		combo_circular_timer.tint_progress = combo_timer_stoped_color
		return
	
	combo_circular_timer.value = time_left_ooo
	if time_left_ooo < 0.66:
		if time_left_ooo < 0.33:
			combo_circular_timer.tint_progress = combo_timer_low_color
		else:
			combo_circular_timer.tint_progress = combo_timer_half_color
	else:
		combo_circular_timer.tint_progress = combo_timer_base_color

func set_combo_amount_text(new_combo_amount : int) -> void:
	new_combo_amount+=1
	combo_amount_label.text = str(new_combo_amount)

func reset_combo_amount_text() -> void:
	combo_amount_label.text = str(0)

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

func update_windows_label(new_windows_amount : int, windows_added : int) -> void:
	windows_label.text = str(new_windows_amount)
	windows_rising_text_pool.release_array_element(str(windows_added))

func update_floor_multiplier_label(new_floor_multiplier : float, multiplier_added : float) -> void:
	floors_label.text = str(new_floor_multiplier, "x")
	floors_rising_text_pool.release_array_element(str(multiplier_added, "x"))

func update_run_coins_label(run_coins : int) -> void:
	final_coins_label.text = str(run_coins, " argentinian pesos!")

func update_run_windows_floors_and_combo(windows : int, spots : int, floors : int, combo : int) -> void:
	final_windows_label.text = str("- ", windows, " windows cleaned.")
	final_spots_label.text = str("- ", spots, " spots cleaned.")
	if floors != -1:
		final_floor_label.text = str("- ", floors, " floors cleaned.")
	if combo != -1:
		final_combo_label.text = str("- ", combo + 1, " max combo achieved.")

func reset_ui() -> void:
	windows_label.text = str(0)
	floors_label.text = str(1.0, "x")

func show_run_stats() -> void:
	end_day_button.disabled = true
	end_stats_panel.visible = true

func _on_end_day_button_pressed() -> void:
	end_stats_panel.visible = false
	on_day_end.emit()

func display_combo(display : bool) -> void:
	combo_ui.visible = display

func display_floors(display : bool) -> void:
	floors_ui.visible = display
