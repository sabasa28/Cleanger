extends Node

signal on_coins_changed(coins_total, coins_just_earned)
signal on_height_changed(current_height, last_height)
signal on_floor_cleaned(floor_cleaned, total_floors_cleaned)
signal on_window_cleaned(run_windows_cleaned)
signal on_spot_cleaned
signal on_run_started
signal on_run_ended
signal on_rotation_speed_changed(current_rot_speed)
signal on_speed_modified(new_speed_modifier : float, new_speed_level : int)
signal on_width_modified(new_width_level : int)
signal on_cleaner_explotion_unlocked()

var gameplay_controller : GameplayController

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
#combo related
var initial_combo_value : int = 0.0
var current_combo_value : int = 0.0
const initial_time_for_combo : float = 10000.0 #in miliseconds
var current_time_for_combo : float 
const time_for_combo_multiplier : float = 0.95
var last_combo_time : float = 0.0
var min_combo_time : float = 0.5
var current_combo_num : int = 0
var current_combo_coins : int = 0
var total_combo_coins : int = 0

var cleaning_power : float = 4.0 #(times to clean spot, lower is better)
var rotation_speed : float = 0.15
var strength_modifier : float = 1.0
var cleaner_width_modifier : float = 1.0
var speed_modifier : float = 1.0
var cleaner_width_level : int = 0
var cleaner_speed_level : int = 0

var necessary_cleanlyness : float = 0.95

var water_bomb_explotion_time_min : float = 0.4
var water_bomb_explotion_time_max : float = 0.7
var water_bomb_explotion_range : float = 1.0 #actually a multiplier
var water_bomb_water_bomb_chance : float = 0.0

var cleaner_explotion_time : float = 10.0
var cleaner_explotion_unlocked : bool = false
var cleaner_explotion_range : float = 2.0 #actually a multiplier
var cleaner_explotion_water_bomb_chance : float = 0.0

#prefabs
var water_bomb_prefab = preload("res://Scenes/water_bomb.tscn")
var explotion_prefab = preload("res://Scenes/water_explotion.tscn")
var spot_prefab = preload("res://Scenes/dirty_spot.tscn")
var window_prefab = preload("res://Scenes/window_square.tscn")

enum explotion_origin
{
	water_bomb,
	regular_explotion
}

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
	total_combo_coins = 0
	current_combo_coins = 0
	current_combo_num = 0
	current_time_for_combo = initial_time_for_combo
	current_combo_value = initial_combo_value
	on_run_ended.emit()

func add_run_coins_to_total() -> void:
	var coins_earned : float = (windows_cleaned * window_value + spots_cleaned * spot_value + golden_spots_cleaned * golden_spot_value + total_combo_coins) * (1.0 + floors_cleaned * floor_value) #aca se multiplicaria con el multiplicador
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
	try_add_combo()
	update_window_related_ui(window_value)
	on_window_cleaned.emit(windows_cleaned)

func try_add_combo() -> void:
	if initial_combo_value == 0.0: #this means we didn't unlock combo yet
		return
	var current_time = Time.get_ticks_msec()
	if ((current_time - last_combo_time) < current_time_for_combo):
		#combo logrado, sigue el combo
		current_time_for_combo *= time_for_combo_multiplier
		current_combo_num += 1
		current_combo_value += initial_combo_value
		current_combo_coins += current_combo_value
	gameplay_controller.set_combo_timer(current_time_for_combo / 1000)
	#print("time between windows cleaned", current_time - last_combo_time)
	last_combo_time = current_time

func on_combo_finished() -> void:
	if current_combo_num > 0: 
			current_time_for_combo = initial_time_for_combo
			current_combo_value = initial_combo_value
			current_combo_num = 0
			total_combo_coins += current_combo_coins
			update_window_related_ui(current_combo_coins)
			current_combo_coins = 0

func check_height(player_height : float, last_player_height : float) -> void:
	on_height_changed.emit(player_height, last_player_height)	

func add_dirty_spot_cleaned() -> void:
	spots_cleaned += 1
	update_window_related_ui(spot_value)
	on_spot_cleaned.emit(spots_cleaned)

func update_window_related_ui(last_value_added : float) -> void:
	InGameUi.update_windows_label(windows_cleaned * window_value + spots_cleaned * spot_value + golden_spots_cleaned * golden_spot_value + total_combo_coins, last_value_added)

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
	initial_combo_value += amount_to_raise

func raise_strength(amount_to_raise : float) -> void:
	strength_modifier += amount_to_raise

func raise_width_level(amount_to_raise : int) -> void:
	cleaner_width_level += amount_to_raise
	on_width_modified.emit(cleaner_width_level)

func raise_speed_level(amount_to_raise : float) -> void:
	speed_modifier += amount_to_raise
	cleaner_speed_level += 1
	on_speed_modified.emit(speed_modifier, cleaner_speed_level)

func lower_necessary_cleanlyness_value(amount_to_lower : float) -> void:
	necessary_cleanlyness -= amount_to_lower

func lower_cleaner_explotion_time(amount_to_lower : float) -> void:
	if !cleaner_explotion_unlocked:
		cleaner_explotion_unlocked = true
		on_cleaner_explotion_unlocked.emit()
	else:
		cleaner_explotion_time -= amount_to_lower

func raise_cleaner_explotion_range(amount_to_raise : float) -> void:
	cleaner_explotion_range += amount_to_raise

func raise_cleaner_explotion_water_bomb_chance(amount_to_raise : float) -> void:
	cleaner_explotion_water_bomb_chance += amount_to_raise

func raise_water_bomb_water_bomb_chance(amount_to_raise : float) -> void:
	water_bomb_water_bomb_chance += amount_to_raise

func get_strength_modifier() -> float:
	return strength_modifier
