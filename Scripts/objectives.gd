class_name objective_manager
extends Node

@export var objectives : Array[objective]
enum possible_objectives {
	clean_windows_1,
	clean_spots_1,
	clean_windows_today_1,
	M_clean_first_3_floors_today,
	coins_mission_1,
	clean_windows_2,
	climb_meters_1,
	M_earn_coins_today_1,
	clean_windows_3,
	reach_floor_1,
	clean_spots_2,
	M_clean_floors_in_zones_1_2_and_3,
	clean_golden_spots_1,
	clean_windows_4,
	coins_mission_12,
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
var minor_objs_completed = 0

var window_spawn_y : float
var window_height : float
var first_3_floors_clean_state : Array[bool]
var windows_cleaned_since_mission : int
var spots_cleaned_since_mission : int
var golden_spots_cleaned_since_mission : int
var coins_earned_since_mission : int
var distance_climbed_since_mission : float

func _ready() -> void:
	first_3_floors_clean_state.resize(3)
	Stats.on_run_ended.connect(reset_run_vars)
	for i in objectives:
		match i.condition:
			possible_objectives.clean_windows_1:
				i.function = Callable(check_clean_windows_1)
				pass
			possible_objectives.clean_spots_1:
				i.function = Callable(check_clean_spots_1)
				pass
			possible_objectives.clean_windows_today_1:
				i.function = Callable(check_clean_windows_today_1)
				pass
			possible_objectives.M_clean_first_3_floors_today:
				i.function = Callable(check_clean_first_3_floors_today)
				pass
			possible_objectives.coins_mission_1:
				i.function = Callable(check_coins_since_mission_1)
				pass
			possible_objectives.clean_windows_2:
				i.function = Callable(check_clean_windows_2)
				pass
			possible_objectives.climb_meters_1:
				i.function = Callable(check_meters_climbed_1)
				pass
			possible_objectives.M_earn_coins_today_1:
				i.function = Callable(check_coins_earned_1)
				pass
			possible_objectives.clean_windows_3:
				i.function = Callable(check_clean_windows_3)
				pass
			possible_objectives.reach_floor_1:
				i.function = Callable(check_player_reach_floor)
				pass
			possible_objectives.clean_spots_2:
				i.function = Callable(check_clean_spots_2)
				pass
			possible_objectives.M_clean_floors_in_zones_1_2_and_3:
				pass
			possible_objectives.clean_golden_spots_1:
				i.function = Callable(check_clean_golden_spots_1)
				pass
			possible_objectives.clean_windows_4:
				i.function = Callable(check_clean_windows_4)
				pass
			possible_objectives.coins_mission_12:
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


func on_objective_completed(condition_met : Callable) -> void:

	var obj : objective
	for i in objectives:
		if i.function == condition_met:
			obj = i
			
	match obj.condition:
		possible_objectives.clean_windows_1:
			Stats.on_window_cleaned.disconnect(obj.function)
			pass
		possible_objectives.clean_spots_1:
			Stats.on_spot_cleaned.disconnect(obj.function)
			pass
		possible_objectives.clean_windows_today_1:
			Stats.on_window_cleaned.disconnect(obj.function)
			pass
		possible_objectives.M_clean_first_3_floors_today:
			Stats.on_floor_cleaned.disconnect(obj.function)
			pass
		possible_objectives.coins_mission_1:
			Stats.on_coins_changed.disconnect(obj.function)
			pass
		possible_objectives.clean_windows_2:
			Stats.on_window_cleaned.disconnect(obj.function)
			pass
		possible_objectives.climb_meters_1:
			Stats.on_height_changed.disconnect(obj.function)
			pass
		possible_objectives.M_earn_coins_today_1:
			Stats.on_coins_changed.disconnect(obj.function)
			pass
		possible_objectives.clean_windows_3:
			Stats.on_window_cleaned.disconnect(obj.function)
			pass
		possible_objectives.reach_floor_1:
			Stats.on_height_changed.disconnect(obj.function)
			pass
		possible_objectives.clean_spots_2:
			Stats.on_spot_cleaned.disconnect(obj.function)
			pass
		possible_objectives.M_clean_floors_in_zones_1_2_and_3:
			pass
		possible_objectives.clean_golden_spots_1:
			Stats.on_spot_cleaned.disconnect(obj.function)
			pass
		possible_objectives.clean_windows_4:
			Stats.on_window_cleaned.disconnect(obj.function)
			pass
		possible_objectives.coins_mission_12:
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
	
	if !objectives[current_obj].is_mayor:
		var minor_obj_num : int = 0
		for i in objectives.size():
			if objectives[i] == obj:
				minor_obj_num = i - current_obj
				break
		InGameUi.cross_out_minor_objective(minor_obj_num)
		minor_objs_completed += 1
		if minor_objs_completed < 3:
			return
	if objectives[current_obj].is_mayor:
		current_obj += 1
	else:
		current_obj += 3
	initiate_objective() 

func initiate_objective() -> void:
	minor_objs_completed = 0
	if objectives[current_obj].is_mayor:
		InGameUi.update_mayor_objective_text(objectives[current_obj].text)
	else:
		InGameUi.update_minor_objective_text(objectives[current_obj].text, objectives[current_obj+1].text, objectives[current_obj+2].text)
	
	var max_i : int = current_obj + 1 if objectives[current_obj].is_mayor else current_obj + 3
	for i in range(current_obj, max_i):
		match objectives[i].condition:
			possible_objectives.clean_windows_1:
				Stats.on_window_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.clean_spots_1:
				Stats.on_spot_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.clean_windows_today_1:
				Stats.on_window_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.M_clean_first_3_floors_today:
				Stats.on_floor_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.coins_mission_1:
				Stats.on_coins_changed.connect(objectives[i].function)
				pass
			possible_objectives.clean_windows_2:
				Stats.on_window_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.climb_meters_1:
				Stats.on_height_changed.connect(objectives[i].function)
				pass
			possible_objectives.M_earn_coins_today_1:
				Stats.on_coins_changed.connect(objectives[i].function)
				pass
			possible_objectives.clean_windows_3:
				Stats.on_window_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.reach_floor_1:
				Stats.on_height_changed.connect(objectives[i].function)
				pass
			possible_objectives.clean_spots_2:
				Stats.on_spot_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.M_clean_floors_in_zones_1_2_and_3:
				pass
			possible_objectives.clean_golden_spots_1:
				Stats.on_spot_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.clean_windows_4:
				Stats.on_window_cleaned.connect(objectives[i].function)
				pass
			possible_objectives.coins_mission_12:
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
		on_objective_completed(check_clean_first_3_floors_today)

func check_clean_windows_1(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 15:
		on_objective_completed(check_clean_windows_1)

func check_clean_windows_2(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 40:
		on_objective_completed(check_clean_windows_2)

func check_clean_windows_3(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 80:
		on_objective_completed(check_clean_windows_3)

func check_clean_windows_4(windows_cleaned) -> void:
	windows_cleaned_since_mission += 1 #el parametro nos da las limpias este dia, para las limpias desde que obtuvimos la mision (o sea que tambien puede ser entre dias) usamos esta var
	if windows_cleaned_since_mission >= 200:
		on_objective_completed(check_clean_windows_4)

func check_clean_windows_today_1(windows_cleaned) -> void:
	if windows_cleaned >= 10:
		on_objective_completed(check_clean_windows_today_1)

func check_clean_spots_1(spots_cleaned) -> void:
	spots_cleaned_since_mission += 1
	if spots_cleaned_since_mission >= 15:
		on_objective_completed(check_clean_spots_1)

func check_clean_spots_2(spots_cleaned) -> void:
	spots_cleaned_since_mission += 1
	if spots_cleaned_since_mission >= 50:
		on_objective_completed(check_clean_spots_2)

func check_clean_golden_spots_1(spots_cleaned) -> void:
	golden_spots_cleaned_since_mission += 1
	if golden_spots_cleaned_since_mission >= 1:
		on_objective_completed(check_clean_golden_spots_1)

func check_player_reach_floor(player_y : float, last_player_y : float) -> void:
	var current_floor = abs((player_y - window_spawn_y) / window_height) + 1 #para no empezar en piso 0 
	if current_floor >= 50: 
		on_objective_completed(check_player_reach_floor)

func check_coins_since_mission_1(total_coins, coins_earned) -> void:
	coins_earned_since_mission += coins_earned
	if coins_earned_since_mission > 100:
		on_objective_completed(check_coins_since_mission_1)

func check_coins_earned_1(total_coins, coins_earned) -> void:
	if coins_earned > 200:
		on_objective_completed(check_coins_earned_1)

func check_meters_climbed_1(player_y : float, last_player_y : float) -> void:
	if player_y > last_player_y: 
		distance_climbed_since_mission += player_y - last_player_y
		if distance_climbed_since_mission > 100:
			on_objective_completed(check_meters_climbed_1)

func reset_run_vars() -> void:
	for i in first_3_floors_clean_state.size():
		first_3_floors_clean_state[i] = false
