class_name WindowParent #si le ponia window escondia otra clase
extends Node2D

var stage_manager
var window_num
var has_spot : bool = false
@export var window_ref : Node2D
var spot : Node2D
var spot_pos_offset : Vector2

var base_cleaned : bool = false #base == window minus the spots

func _ready() -> void:
	if has_spot:
		spot_pos_offset = window_ref.image_size / 4.0
		var spawned_spot
		spot = Stats.spot_prefab.instantiate()
		var versorX = 1.0 if randi() % 2 else -1.0
		var versorY = 1.0 if randi() % 2 else -1.0
		var spot_vector_offset = Vector2(versorX, versorY) * spot_pos_offset
		print(global_position)
		spot.global_position = global_position + spot_vector_offset
		print(global_position + spot_vector_offset)
		spot.window_ref = self
		add_sibling(spot)

func on_base_cleaned() -> void:
	base_cleaned = true
	if has_spot == false:
		on_window_cleaned()

func on_spot_cleaned() -> void:
	has_spot = false
	if base_cleaned == true:
		on_window_cleaned()

func on_window_cleaned() -> void:
	stage_manager.on_window_cleaned(window_num)
	# HERE WE PLAY SATISFYING CLEAN GLASS ANIMATION + SOUND

func delete_window() -> void:
	if spot != null:
		spot.queue_free()
	queue_free()
