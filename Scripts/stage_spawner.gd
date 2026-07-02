extends Node2D

var window_prefab = preload("res://Scenes/window_square.tscn")
@export var window_interval : Vector2
@export var window_spawn_origin : Vector2
@export var rowsAndColumns : Vector2i

func _ready() -> void:
	var spawned_window : Node2D
	
	for columns in rowsAndColumns.y:
		for rows in rowsAndColumns.x:
			spawned_window = window_prefab.instantiate()
			add_child(spawned_window)
			spawned_window.global_position = window_spawn_origin + Vector2 (window_interval.x * rows, -window_interval.y * columns)
		


func _process(delta: float) -> void:
	pass
