class_name upgrade
extends Resource

enum description_modifiers
{
	none,
	percentage,
	modifier_N_minus_val,
}

@export var name : String
@export var initial_description : String ## & se reemplaza por Upgrade Main Amount y @ por Upgrade Extra Amount
@export var description : String ## & se reemplaza por Upgrade Main Amount y @ por Upgrade Extra Amount
@export_group("Description modifier")
var char_to_replace : String = "&"
var extra_char_to_replace : String = "@"
@export var description_modifier : description_modifiers
@export var modifier_N : float = 0.0
@export var extra_modifier_N : float = 0.0
@export var force_to_int : bool = true
@export_group("")
@export var upgrade_price : Array[int]
@export var upgrade_main_amount : float
@export_group("Extra")
@export var upgrade_extra_amount : float
@export_group("")

var upgrade_times : int
var current_level : int = 0
@export var stat_to_modify : modifiable_stat
@export var button : NodePath

@export_category("Dependencies")
@export var dependency_upgrade : upgrade
@export var lvl_of_dependency : int
#export var dependency_achievement : achievement

var button_node : upgrade_button
var initiated : bool = false
var available : bool = false
enum modifiable_stat
{
	floor_modifier_lock,
	coins_per_window,
	coins_per_spot,
	coins_per_combo,
	cleaner_strength,
	cleaner_width,
	cleaner_speed,
	water_bomb_cd,
	necessary_cleanlyness,
	cleaner_explotion_times,
	cleaner_explotion_range,
	explotion_water_bomb_chance,
	spots_chance_to_trigger_explotion,
	water_bomb_instant_clean_chance,
	water_bomb_explotion_range,
	super_water_bomb_enabled,
	pelican_spawn_time,
	water_pelican_chance,
	persistent_pelicans_enabled,
	combo_timer_speed,
	stun_resistance,
	explotions_range_buff
}

func try_init(upgrade_num : int) -> void:
	if initiated == true:
		return
	if initial_description == "":
		initial_description = description
	upgrade_times = upgrade_price.size()

func update_button_and_menu() -> void:
	#aca segun si esta desbloqueda y si no tiene dependencia bloqueda seteamos si se ve y si se ve gris o normal
	if available && current_level < upgrade_times:
		button_node.get_child(0).update_ui(name, get_description_text(), upgrade_price[current_level])
		button_node.on_unlock()
	else:
		button_node.get_child(0).change_enabled_state(false)

func update_available() -> void:
	if available:
		return
	var turn_available : bool = false
	if dependency_upgrade == null:
		turn_available = true
	elif dependency_upgrade.current_level >= lvl_of_dependency:
		turn_available = true
	
	if turn_available:
		available = true
		update_button_and_menu()

func apply_upgrade() -> bool:
	if current_level >= upgrade_times || !available:
		return false
	if upgrade_price[current_level] <= Stats.total_coins:
		Stats.try_remove_coins_from_total(upgrade_price[current_level])
	else:
		return false
	match stat_to_modify:
		modifiable_stat.floor_modifier_lock:
			Stats.raise_floor_value(upgrade_main_amount)
		modifiable_stat.coins_per_window:
			Stats.raise_window_value(upgrade_main_amount)
		modifiable_stat.coins_per_spot:
			Stats.raise_spot_value(upgrade_main_amount)
		modifiable_stat.coins_per_combo:
			Stats.raise_combo_value(upgrade_main_amount)
		modifiable_stat.cleaner_strength:
			Stats.raise_strength(upgrade_main_amount)
		modifiable_stat.cleaner_width:
			Stats.raise_width_level(upgrade_main_amount)
		modifiable_stat.cleaner_speed:
			Stats.raise_speed_level(upgrade_main_amount)
		modifiable_stat.water_bomb_cd:
			Stats.lower_pasive_water_bomb_max_cd(upgrade_main_amount)
		modifiable_stat.necessary_cleanlyness:
			Stats.lower_necessary_cleanlyness_value(upgrade_main_amount)
		modifiable_stat.cleaner_explotion_times:
			Stats.lower_cleaner_explotion_times(upgrade_main_amount)
		modifiable_stat.cleaner_explotion_range:
			Stats.raise_cleaner_explotion_range(upgrade_main_amount)
		modifiable_stat.explotion_water_bomb_chance:
			Stats.raise_cleaner_explotion_water_bomb_chance(upgrade_main_amount)
		modifiable_stat.spots_chance_to_trigger_explotion:
			Stats.raise_spots_explotion_chance(upgrade_main_amount)
		modifiable_stat.water_bomb_instant_clean_chance:
			Stats.raise_water_bomb_instant_clean_chance(upgrade_main_amount)
		modifiable_stat.water_bomb_explotion_range:
			Stats.raise_water_bomb_explotion_range(upgrade_main_amount)
		modifiable_stat.super_water_bomb_enabled:
			Stats.enable_super_water_bomb()
		modifiable_stat.pelican_spawn_time:
			Stats.lower_max_pelican_time(upgrade_main_amount)
		modifiable_stat.water_pelican_chance:
			Stats.raise_water_pelican_chance(upgrade_main_amount)
		modifiable_stat.persistent_pelicans_enabled:
			Stats.enable_persistent_pelicans()
		modifiable_stat.combo_timer_speed:
			Stats.lower_combo_timer_speed(upgrade_main_amount)
		modifiable_stat.stun_resistance:
			Stats.raise_stun_resistance(upgrade_main_amount)
		modifiable_stat.explotions_range_buff:
			Stats.raise_all_explotions_range_buff(upgrade_main_amount)
	current_level += 1
	if current_level == 1:
		button_node.on_bought()
	if current_level == upgrade_times:
		button_node.on_maxed()
	update_button_and_menu()
	return true

func get_description_text() -> String:
	var final_string : String = initial_description if current_level == 0 else description
	var replacement_num : float
	var replacement_prev_num : float
	var extra_replacement_num : float
	var extra_replacement_prev_num : float
	
	var lvl_multiplier : int = current_level + 1
	
	match description_modifier:
		description_modifiers.none:
			replacement_num = upgrade_main_amount * lvl_multiplier
			extra_replacement_num = upgrade_extra_amount * lvl_multiplier
			replacement_prev_num = upgrade_main_amount * (lvl_multiplier - 1.0)
			extra_replacement_prev_num = upgrade_extra_amount * (lvl_multiplier - 1.0)
		description_modifiers.percentage:
			replacement_num = upgrade_main_amount * lvl_multiplier * 100.0
			extra_replacement_num = upgrade_extra_amount * lvl_multiplier * 100.0
			replacement_prev_num = upgrade_main_amount * (lvl_multiplier - 1.0) * 100.0
			extra_replacement_prev_num = upgrade_extra_amount * (lvl_multiplier - 1.0) * 100.0
		description_modifiers.modifier_N_minus_val:
			replacement_num = modifier_N - upgrade_main_amount * lvl_multiplier
			extra_replacement_num = extra_modifier_N - upgrade_extra_amount * lvl_multiplier
			replacement_prev_num = modifier_N - upgrade_main_amount * (lvl_multiplier - 1.0)
			extra_replacement_prev_num = extra_modifier_N - upgrade_extra_amount * (lvl_multiplier - 1.0)
	
	var replacement_string : String = str(int(replacement_num) if force_to_int else replacement_num)
	var extra_replacement_string : String = str(int(extra_replacement_num) if force_to_int else extra_replacement_num)
	if description_modifier == description_modifiers.percentage:
		replacement_string += "%"
		extra_replacement_string += "%"
	
	if current_level != 0:
		var replacement_prev_string : String = str(int(replacement_prev_num) if force_to_int else replacement_prev_num)
		var extra_replacement_prev_string : String = str(int(extra_replacement_prev_num) if force_to_int else extra_replacement_prev_num)
		if description_modifier == description_modifiers.percentage:
			replacement_prev_string += "%"
			extra_replacement_prev_string += "%"
		replacement_string = str("[i]", replacement_prev_string, "[/i]", " => ", replacement_string)
		extra_replacement_string = str("[i]", extra_replacement_prev_string, "[/i]", " => ", extra_replacement_string)
	
	final_string = final_string.replace(char_to_replace, replacement_string)
	final_string = final_string.replace(extra_char_to_replace, extra_replacement_string)
	return final_string
