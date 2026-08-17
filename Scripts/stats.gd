extends Node

signal on_coins_changed(coins_total, coins_just_earned)
signal on_height_changed(current_height, last_height)
signal on_floor_cleaned(floor_cleaned, total_floors_cleaned)
signal on_window_cleaned(run_windows_cleaned)
signal on_spot_cleaned
signal on_run_started
signal on_run_ended
signal on_rotation_speed_changed(current_rot_speed)

var total_coins : int
var floors_cleaned : int
var current_floor : int
var windows_cleaned : int
var total_runs : int
var spots_cleaned : int
var golden_spots_cleaned : int
var window_value : float = 10.0
var floor_value : float = 0.0
var spot_value : float = 2.0
var golden_spot_value : float = 50.0
var combo_value : float = 0.0
var cleaning_power : float = 1.0
var time_to_clean_spot
var rotation_speed : float = 0.15
var strength_modifier : float = 1.0
var cleaner_width_modifier : float = 1.0
var speed_modifier : float = 1.0

func start_run() -> void:
	on_run_started.emit()
	InGameUi.reset_ui()

func end_run() -> void:
	add_run_coins_to_total()
	total_runs += 1
	floors_cleaned = 0
	windows_cleaned = 0
	spots_cleaned = 0
	golden_spots_cleaned = 0
	on_run_ended.emit()

func add_run_coins_to_total() -> void:
	var coins_earned : float = (windows_cleaned * window_value + spots_cleaned * spot_value + golden_spots_cleaned * golden_spot_value) * (1.0 + floors_cleaned * floor_value) #aca se multiplicaria con el multiplicador
	total_coins += coins_earned
	on_coins_changed.emit(total_coins, coins_earned)

func try_remove_coins_from_total(coins_to_remove : int) -> bool:
	if coins_to_remove < total_coins:
		total_coins -= coins_to_remove
		on_coins_changed.emit(total_coins, 0)
		return true
	else:
		return false

func add_floor_cleaned(floor_cleaned : int) -> void:
	floors_cleaned += 1
	InGameUi.update_floor_multiplier_label(1.0 + floors_cleaned * floor_value, floor_value)
	on_floor_cleaned.emit(floor_cleaned, floors_cleaned)

func add_window_cleaned() -> void:
	windows_cleaned += 1
	InGameUi.update_windows_label(windows_cleaned * window_value + spots_cleaned * spot_value + golden_spots_cleaned * golden_spot_value, window_value)
	on_window_cleaned.emit(windows_cleaned)

func check_height(player_height : float, last_player_height : float) -> void:
	on_height_changed.emit(player_height, last_player_height)	

func add_dirty_spot_cleaned() -> void:
	spots_cleaned += 1
	InGameUi.update_windows_label(windows_cleaned * window_value + spots_cleaned * spot_value + golden_spots_cleaned * golden_spot_value, spot_value)
	on_spot_cleaned.emit(spots_cleaned)

func update_cleaning_power(new_cleaning_power : float) -> void:
	cleaning_power = new_cleaning_power

func get_cleaning_power() -> float:
	return cleaning_power

func set_rotation_speed(new_speed : float) -> void:
	rotation_speed = new_speed
	on_rotation_speed_changed.emit(rotation_speed)

func raise_window_value(amount_to_raise : float) -> void:
	window_value += amount_to_raise

func raise_floor_value(amount_to_raise : float) -> void:
	floor_value += amount_to_raise

func raise_spot_value(amount_to_raise : float) -> void:
	spot_value += amount_to_raise

func raise_golden_spot_value(amount_to_raise : float) -> void:
	golden_spot_value += amount_to_raise

func raise_combo_value(amount_to_raise : float) -> void:
	combo_value += amount_to_raise

func raise_strength(amount_to_raise : float) -> void:
	strength_modifier += amount_to_raise

func raise_cleaner_width(amount_to_raise : float) -> void:
	cleaner_width_modifier += amount_to_raise

func raise_speed(amount_to_raise : float) -> void:
	speed_modifier += amount_to_raise

func get_strength_modifier() -> float:
	return strength_modifier
