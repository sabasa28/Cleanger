extends Node

signal on_coins_changed(coins_total, coins_just_earned)
signal on_height_changed(current_height, last_height)
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
var golden_spots_cleaned : int
var window_value : float = 1.0
var floor_value : float = 0.1
var base_time_to_clean_spot : float = 1.0
var cleaning_power : float = 1.0
var time_to_clean_spot

func _ready() -> void: #calculate vars
	time_to_clean_spot = base_time_to_clean_spot / cleaning_power

func end_run() -> void:
	add_run_coins_to_total()
	total_runs += 1
	floors_cleaned = 0
	windows_cleaned = 0
	spots_cleaned = 0
	golden_spots_cleaned = 0

func add_run_coins_to_total() -> void:
	var coins_earned = windows_cleaned * window_value * (1.0 + floors_cleaned * floor_value) #aca se multiplicaria con el multiplicador
	total_coins += coins_earned
	on_coins_changed.emit(total_coins, coins_earned)

func add_floor_cleaned(floor_cleaned : int) -> void:
	floors_cleaned += 1
	on_floor_cleaned.emit(floor_cleaned, floors_cleaned)

func add_window_cleaned() -> void:
	windows_cleaned += 1
	on_window_cleaned.emit(windows_cleaned)

func check_height(player_height : float, last_player_height : float) -> void:
	on_height_changed.emit(player_height, last_player_height)	

func add_dirty_spot_cleaned() -> void:
	spots_cleaned += 1
	on_spot_cleaned.emit(spots_cleaned)

func update_cleaning_power(new_cleaning_power : float) -> void:
	cleaning_power = new_cleaning_power
	time_to_clean_spot = base_time_to_clean_spot / cleaning_power

func get_time_to_clean_spot() -> float:
	return time_to_clean_spot
