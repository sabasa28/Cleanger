class_name WindowParent #si le ponia window escondia otra clase
extends Node2D

var stage_manager
var window_num
var has_spot : bool = false
@export var window_ref : Node2D
var spot_pos_offset : Vector2
var spot_prefab = preload("res://Scenes/dirty_spot.tscn")

func _ready() -> void:
	if has_spot:
		spot_pos_offset = window_ref.image_size / 4.0
		var spawned_spot
		spawned_spot = spot_prefab.instantiate()
		add_child(spawned_spot)
		var versorX = 1.0 if randi() % 2 else -1.0
		var versorY = 1.0 if randi() % 2 else -1.0
		var spot_vector_offset = Vector2(versorX, versorY) * spot_pos_offset
		spawned_spot.global_position = global_position + spot_vector_offset 

func on_window_cleaned() -> void:
	stage_manager.on_window_cleaned(window_num)
