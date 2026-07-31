extends Node2D

var window_prefab = preload("res://Scenes/window_square.tscn")
@export var window_interval : Vector2
@export var window_spawn_origin : Vector2
@export var columns_and_rows : Vector2i
var windows_state : Array[bool]
var floors_state : Array[bool]

signal on_reset_windows

func _ready() -> void:
	Objectives.window_height = window_interval.y
	Objectives.window_spawn_y = window_spawn_origin.y

func on_window_cleaned(window_num : int) -> void:
	windows_state[window_num] = true
	Stats.add_window_cleaned()
	var floor : int = window_num / columns_and_rows.x
	var floor_cleaned = true
	for i in range(floor * columns_and_rows.x, floor * columns_and_rows.x + columns_and_rows.x):
		if !windows_state[i]:
			floor_cleaned = false
			break
	if floor_cleaned:
		floors_state[floor] = true
		Stats.add_floor_cleaned(floor)

func reset_windows() -> void:
	on_reset_windows.emit()
	windows_state.clear()
	floors_state.clear()
	var spawned_window : Node2D
	windows_state.resize(columns_and_rows.x * columns_and_rows.y + columns_and_rows.x)
	floors_state.resize(columns_and_rows.y)
	for floor in floors_state:
		floor = false
	for rows in columns_and_rows.y:
		for columns in columns_and_rows.x:
			spawned_window = window_prefab.instantiate()
			on_reset_windows.connect(spawned_window.delete_window) 
			spawned_window.has_spot = randi() % 2
			add_child(spawned_window)
			spawned_window.global_position = window_spawn_origin + Vector2 (window_interval.x * columns, -window_interval.y * rows)
			spawned_window.stage_manager = self
			var current_window_num = rows * columns_and_rows.x + columns
			spawned_window.window_num = current_window_num
			windows_state[current_window_num] = false
