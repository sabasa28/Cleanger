class_name upgrade
extends Resource

@export var name : String
@export var description : String
@export var upgrade_amount : Array[float]
@export var upgrade_price : Array[int]
var upgrade_times : int
var current_level : int = 0
@export var stat_to_modify : modifiable_stat
@export var button : NodePath

@export_category("Dependencies")
@export var dependency_upgrade : upgrade
@export var lvl_of_dependency : int
#export var dependency_achievement : achievement

var button_node : Node
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
	water_supply,
	water_explotion_cd,
	water_explotion_range,
	water_explotion_water_bomb_chance,
	water_bomb_cd,
	water_carrying_bird_cd,
	cleaner_rot_speed,
	bomb_carrying_bird_cd,
}

func try_init(upgrade_num : int) -> void:
	if initiated == true:
		return
	upgrade_times = upgrade_amount.size()
	if upgrade_amount.size() != upgrade_price.size():
		print("upgrade times has conflict")

func update_button_and_menu() -> void:
	#aca segun si esta desbloqueda y si no tiene dependencia bloqueda seteamos si se ve y si se ve gris o normal
	if available && current_level < upgrade_times:
		button_node.get_child(0).update_ui(name, description, upgrade_price[current_level])
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
				Stats.raise_floor_value(upgrade_amount[current_level])
			modifiable_stat.coins_per_window:
				Stats.raise_window_value(upgrade_amount[current_level])
			modifiable_stat.coins_per_spot:
				Stats.raise_spot_value(upgrade_amount[current_level])
			modifiable_stat.coins_per_combo:
				Stats.raise_combo_value(upgrade_amount[current_level])
			modifiable_stat.cleaner_strength:
				Stats.raise_strength(upgrade_amount[current_level])
			modifiable_stat.cleaner_width:
				Stats.raise_width_level(upgrade_amount[current_level])
			modifiable_stat.cleaner_speed:
				Stats.raise_speed_level(upgrade_amount[current_level])
			modifiable_stat.water_supply:
				pass
			modifiable_stat.water_explotion_cd:
				pass
			modifiable_stat.water_explotion_range:
				pass
			modifiable_stat.water_explotion_water_bomb_chance:
				pass
			modifiable_stat.water_bomb_cd:
				pass
			modifiable_stat.water_carrying_bird_cd:
				pass
			modifiable_stat.cleaner_rot_speed:
				pass
			modifiable_stat.bomb_carrying_bird_cd:
				pass
	current_level += 1
	update_button_and_menu()
	return true
