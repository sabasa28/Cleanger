class_name GameplayController

extends Node2D

var timer_end : float
var current_timer : float = 0.0
var combo_timer : float = 0.0
var initial_combo_time : float = 0.0
var running_combo_timer : bool = false
var combo_timer_speed : float = 1.0
var on_cleaning_phase : bool = false
var current_objective
@export var stage_spawner : Node2D
@export var run_time : float
var overtime_time : float = 25.0
@export var player : Player
@export var upgrades_ui : Node
var min_time_between_pelican_spawn : float
var max_time_between_pelican_spawn : float
@export var pelican_max_heigh_dist_to_player : float
@export var min_pelican_height_spawn : float
@export var pelican_offset_to_limits : float
var time_until_next_pelican_spawn : float
var pelican_spawn_timer : float = 0.0
var water_pelican_chance : float = 0.0
var left_limit : float
var right_limit : float
var map_length : float
@export var collision_limit_L : Node2D
@export var collision_limit_R : Node2D
@export var collision_limit_Roof : Node2D
@export var collision_limits_offset : float
@export var building_visual : TextureRect
@export var building_offset_to_windows : float
@export var atmosphere_light_light_panel : ColorRect
@export var atmosphere_dark_light_panel : ColorRect
@export var initial_alpha : float
@export var final_alpha : float
var on_overtime : bool = false

func _ready() -> void:
	atmosphere_light_light_panel.color = Color.LIGHT_GOLDENROD
	atmosphere_dark_light_panel.color = Color.MIDNIGHT_BLUE
	var map_limits = Stats.get_map_h_limits()
	left_limit = map_limits.x
	right_limit = map_limits.y
	map_length = right_limit - left_limit
	collision_limit_L.global_position.x = left_limit - collision_limits_offset
	collision_limit_R.global_position.x = right_limit + collision_limits_offset
	var map_height = Stats.get_map_highest_point()
	collision_limit_Roof.global_position.y = map_height - collision_limits_offset
	building_visual.size = Vector2(map_length + building_offset_to_windows * 2.0, -map_height + building_offset_to_windows)
	building_visual.global_position = Vector2(-building_visual.size.x / 2.0, -building_visual.size.y)
	stage_spawner.reset_windows()
	InGameUi.on_day_end.connect(end_day)
	Stats.gameplay_controller = self
	Stats.set_initial_values()
	timer_end = run_time + overtime_time
	combo_timer_speed = Stats.combo_time_lowering_speed
	upgrades_ui.on_upgrades_finished.connect(start_cleaning_phase)
	start_cleaning_phase()
	max_time_between_pelican_spawn = Stats.max_time_pelican_spawn
	time_until_next_pelican_spawn = randf_range(min_time_between_pelican_spawn, max_time_between_pelican_spawn)

func start_cleaning_phase() -> void:
	water_pelican_chance = Stats.water_pelican_chance
	upgrades_ui.visible = false
	on_cleaning_phase = true
	player.reset()
	combo_timer_speed = Stats.combo_time_lowering_speed
	max_time_between_pelican_spawn = Stats.max_time_pelican_spawn
	time_until_next_pelican_spawn = randf_range(min_time_between_pelican_spawn, max_time_between_pelican_spawn)
	current_timer = 0.0
	atmosphere_dark_light_panel.color.a = initial_alpha
	atmosphere_light_light_panel.color.a = 0.0
	on_overtime = false
	InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
	stop_combo_timer()
	Stats.start_run()

func end_cleaning_phase() -> void:
	Stats.on_combo_finished()
	on_cleaning_phase = false
	Stats.end_run()
	player.pause()
	stop_combo_timer()
	show_run_stats()

func show_run_stats() -> void:
	InGameUi.show_run_stats()

func end_day() -> void:
	upgrades_ui.prepare_and_set_visible()

func _process(delta: float) -> void:
	if on_cleaning_phase:
		if current_timer >= timer_end:
			end_cleaning_phase()
		else:
			if current_timer <= run_time:
				if current_timer < run_time / 2.0:
					if current_timer < run_time / 4.0:
						atmosphere_dark_light_panel.color.a = lerpf(initial_alpha, 0.0, current_timer / (run_time / 4.0))
					else:
						atmosphere_light_light_panel.color.a = lerpf(0.0, initial_alpha, (current_timer - (run_time / 4.0)) / (run_time / 4.0))
				else:
					atmosphere_light_light_panel.color.a = lerpf(initial_alpha, 0.0, (current_timer - (run_time / 2.0)) / (run_time / 2.0))
			elif !on_overtime:
				on_overtime = true
				atmosphere_dark_light_panel.color.a = lerpf(0.0, final_alpha, (current_timer - run_time) / overtime_time)
			else:
				atmosphere_dark_light_panel.color.a = lerpf(0.0, final_alpha, (current_timer - run_time) / overtime_time)
			current_timer += delta
			InGameUi.set_timer_text((int)(timer_end - current_timer))#por la conversion pierdo tiempo visualmente?
		if running_combo_timer:
			combo_timer -= delta * combo_timer_speed
			if combo_timer <= 0.0:
				combo_timer = 0.0
				running_combo_timer = false
				Stats.on_combo_finished()
			InGameUi.set_combo_timer_text((int)(combo_timer), combo_timer / initial_combo_time)
		pelican_spawn_timer += delta
		if pelican_spawn_timer >= time_until_next_pelican_spawn:
			var spawned_pelican : Node2D = Stats.pelican_prefab.instantiate()
			var going_right = true if randi_range(0,1) == 0 else false
			var spawn_pos_x : float = left_limit - pelican_offset_to_limits if going_right else right_limit + pelican_offset_to_limits
			var spawn_pos : Vector2 = Vector2(spawn_pos_x, minf(player.global_position.y, min_pelican_height_spawn) - randf_range(0.0, pelican_max_heigh_dist_to_player)).round()
			var is_water_pelican : bool = randf() < water_pelican_chance
			spawned_pelican.global_position = spawn_pos
			add_child(spawned_pelican)
			spawned_pelican.initialize(going_right, map_length + pelican_offset_to_limits, is_water_pelican, Stats.persistent_pelicans_enabled)
			pelican_spawn_timer = 0.0
			time_until_next_pelican_spawn = randf_range(min_time_between_pelican_spawn, max_time_between_pelican_spawn)


func set_combo_timer(new_time : float) -> void:
	running_combo_timer = true
	combo_timer = new_time
	initial_combo_time = combo_timer

func stop_combo_timer() -> void:
	running_combo_timer = false
	combo_timer = 0.0
	InGameUi.set_combo_timer_text(0, 0.0)
