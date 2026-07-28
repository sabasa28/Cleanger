extends Node

signal on_coins_changed(current_run_coins)
signal on_height_changed(current_height)
signal on_floor_cleaned(floor_cleaned, total_floors_cleaned)
signal on_window_cleaned(run_windows_cleaned)
signal on_spot_cleaned
signal on_run_started
signal on_run_ended

var total_coins : int
var floors_cleaned : int
var current_floor : int
var windows_cleaned : int
var total_runs : int
var spots_cleaned : int
var run_golden_spots_cleaned : int
var window_value : int
var floor_value : float
var base_time_to_clean_spot : float = 1.0
var cleaning_power : float = 1.0
var time_to_clean_spot

func _ready() -> void: #calculate vars
	time_to_clean_spot = base_time_to_clean_spot / cleaning_power

func add_run_coins_to_total() -> void:
	total_coins += windows_cleaned * window_value * (1.0 + floors_cleaned * floor_value) #aca se multiplicaria con el multiplicador
	on_coins_changed.emit(total_coins)

func add_floor_cleaned(floor_cleaned : int) -> void:
	floors_cleaned += 1
	on_floor_cleaned.emit(floor_cleaned, floors_cleaned)

func add_window_cleaned() -> void:
	windows_cleaned += 1
	on_window_cleaned.emit(windows_cleaned)

func check_height(player_height : float) -> void:
	on_height_changed.emit(player_height)	

func add_dirty_spot_cleaned() -> void:
	spots_cleaned += 1
	on_spot_cleaned.emit(spots_cleaned)

func update_cleaning_power(new_cleaning_power : float) -> void:
	cleaning_power = new_cleaning_power
	time_to_clean_spot = base_time_to_clean_spot / cleaning_power

func get_time_to_clean_spot() -> float:
	return time_to_clean_spot
