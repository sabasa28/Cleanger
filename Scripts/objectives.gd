class_name objective_manager
extends Node

@export var objectives : Array[objective]
enum possible_objectives {
	clean_windows_1,
	clean_spots_1,
	clean_windows_today_1,
	M_clean_first_3_floors_today,
	coins_mission_REVISAR,
	clean_windows_2,
	climb_meters_1,
	M_earn_coins_today_1,
	clean_windows_3,
	reach_floor_1,
	clean_spots_2,
	M_clean_floors_in_zones_1_2_and_3,
	clean_golden_spots_1,
	clean_windows_4,
	coins_mission_REVISAR2,
	M_clean_floors_today_1,
	clean_windows_with_bombs_1,
	travel_meters_1,
	clean_spots_and_golden_spots_1,
	M_clean_floor_on_zone_5_only,
	reach_peak,
	kill_yourself
	
}

var current_obj = 0
var player_stats_ref : Stats

var window_spawn_y : float
var window_height : float
var first_3_floors_clean_state : Array[bool]
var windows_cleaned_since_mission : int
var spots_cleaned_since_mission : int
var golden_spots_cleaned_since_mission : int
const floor_to_reach : int = 5

func _ready() -> void:
	first_3_floors_clean_state.resize(3)

func on_objective_completed() -> void:
	match objectives[current_obj].condition:
		possible_objectives.clean_windows_1:
			Stats.on_window_cleaned.disconnect(check_clean_windows_1)
			pass
		possible_objectives.clean_spots_1:
			Stats.on_spot_cleaned.disconnect(check_clean_spots_1)
			pass
		possible_objectives.clean_windows_today_1:
			Stats.on_window_cleaned.disconnect(check_clean_windows_today_1)
			pass
		possible_objectives.M_clean_first_3_floors_today:
			Stats.on_floor_cleaned.disconnect(check_clean_first_3_floors_today)
			pass
		possible_objectives.coins_mission_REVISAR:
			pass
		possible_objectives.clean_windows_2:
			Stats.on_window_cleaned.disconnect(check_clean_windows_2)
			pass
		possible_objectives.climb_meters_1:
			pass
		possible_objectives.M_earn_coins_today_1:
			pass
		possible_objectives.clean_windows_3:
			Stats.on_window_cleaned.disconnect(check_clean_windows_3)
			pass
		possible_objectives.reach_floor_1:
			Stats.on_height_changed.disconnect(check_player_reach_floor)
			pass
		possible_objectives.clean_spots_2:
			Stats.on_spot_cleaned.disconnect(check_clean_spots_2)
			pass
		possible_objectives.M_clean_floors_in_zones_1_2_and_3:
			pass
		possible_objectives.clean_golden_spots_1:
			Stats.on_spot_cleaned.disconnect(check_clean_golden_spots_1)
			pass
		possible_objectives.clean_windows_4:
			Stats.on_window_cleaned.disconnect(check_clean_windows_4)
			pass
		possible_objectives.coins_mission_REVISAR2:
			pass
		possible_objectives.M_clean_floors_today_1:
			pass
		possible_objectives.clean_windows_with_bombs_1:
			pass
		possible_objectives.travel_meters_1:
			pass
		possible_objectives.clean_spots_and_golden_spots_1:
			pass
		possible_objectives.M_clean_floor_on_zone_5_only:
			pass
		possible_objectives.reach_peak:
			pass
		possible_objectives.kill_yourself:
			pass
	current_obj += 1
	initiate_objective() 

func initiate_objective() -> void:
	InGameUi.update_objective_text(objectives[current_obj].text)
	match objectives[current_obj].condition:
		possible_objectives.clean_windows_1:
			Stats.on_window_cleaned.connect(check_clean_windows_1)
			pass
		possible_objectives.clean_spots_1:
			Stats.on_spot_cleaned.connect(check_clean_spots_1)
			pass
		possible_objectives.clean_windows_today_1:
			Stats.on_window_cleaned.connect(check_clean_windows_today_1)
			pass
		possible_objectives.M_clean_first_3_floors_today:
			Stats.on_floor_cleaned.connect(check_clean_first_3_floors_today)
			pass
		possible_objectives.coins_mission_REVISAR:
			pass
		possible_objectives.clean_windows_2:
			Stats.on_window_cleaned.connect(check_clean_windows_2)
			pass
		possible_objectives.climb_meters_1:
			pass
		possible_objectives.M_earn_coins_today_1:
			pass
		possible_objectives.clean_windows_3:
			Stats.on_window_cleaned.connect(check_clean_windows_3)
			pass
		possible_objectives.reach_floor_1:
			Stats.on_height_changed.connect(check_player_reach_floor)
			pass
		possible_objectives.clean_spots_2:
			Stats.on_spot_cleaned.connect(check_clean_spots_2)
			pass
		possible_objectives.M_clean_floors_in_zones_1_2_and_3:
			pass
		possible_objectives.clean_golden_spots_1:
			Stats.on_spot_cleaned.connect(check_clean_golden_spots_1)
			pass
		possible_objectives.clean_windows_4:
			Stats.on_window_cleaned.connect(check_clean_windows_4)
			pass
		possible_objectives.coins_mission_REVISAR2:
			pass
		possible_objectives.M_clean_floors_today_1:
			pass
		possible_objectives.clean_windows_with_bombs_1:
			pass
		possible_objectives.travel_meters_1:
			pass
		possible_objectives.clean_spots_and_golden_spots_1:
			pass
		possible_objectives.M_clean_floor_on_zone_5_only:
			pass
		possible_objectives.reach_peak:
			pass
		possible_objectives.kill_yourself:
			pass

func check_clean_first_3_floors_today(last_floor_cleaned : int, total_floors_cleaned : int) -> void:
	var mission_floors_cleaned : bool = false
	
	for i in first_3_floors_clean_state.size():
		if i == last_floor_cleaned && first_3_floors_clean_state[i] == false:
			first_3_floors_clean_state[i] = true
			mission_floors_cleaned = true
			for j in first_3_floors_clean_state.size():
				if !first_3_floors_clean_state[j]:
					mission_floors_cleaned = false
					break
	if mission_floors_cleaned:
		on_objective_completed()

func check_clean_windows_1(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 15:
		on_objective_completed()

func check_clean_windows_2(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 40:
		on_objective_completed()

func check_clean_windows_3(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 80:
		on_objective_completed()

func check_clean_windows_4(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 200:
		on_objective_completed()

func check_clean_windows_today_1(windows_cleaned) -> void:
	if windows_cleaned >= 10:
		on_objective_completed()

func check_clean_spots_1(spots_cleaned) -> void:
	spots_cleaned_since_mission += 1
	if spots_cleaned_since_mission >= 15:
		on_objective_completed()

func check_clean_spots_2(spots_cleaned) -> void:
	spots_cleaned_since_mission += 1
	if spots_cleaned_since_mission >= 50:
		on_objective_completed()

func check_clean_golden_spots_1(spots_cleaned) -> void:
	golden_spots_cleaned_since_mission += 1
	if golden_spots_cleaned_since_mission >= 1:
		on_objective_completed()

func check_player_reach_floor(player_y : float) -> void:
	var current_floor = abs((player_y - window_spawn_y) / window_height) + 1 #para no empezar en piso 0 
	if current_floor > floor_to_reach: 
		on_objective_completed()
