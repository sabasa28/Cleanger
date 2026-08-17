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
@export var dependant_of : upgrade
var button_node : Node
var initiated : bool = false
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
	button_node.get_child(0).update_ui(name, description, upgrade_price[current_level])

func apply_upgrade() -> void:
	if current_level >= upgrade_price.size():
		return
	if upgrade_price[current_level] <= Stats.total_coins:
		Stats.try_remove_coins_from_total(upgrade_price[current_level])
	else:
		return
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
				Stats.raise_cleaner_width(upgrade_amount[current_level])
			modifiable_stat.cleaner_speed:
				Stats.raise_speed(upgrade_amount[current_level])
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
	
