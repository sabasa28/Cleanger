extends Node2D

var being_cleaned : bool = false

@export var cleaning_resistance : int = 4
var dirt_left : int
var cleaner_ref
var window_ref
@export var sprite : Node2D

func _ready() -> void:
	dirt_left = cleaning_resistance

func _on_area_2d_area_entered(area: Area2D) -> void:
	if being_cleaned:
		return
	if area.is_in_group("Cleaner"):
		cleaner_ref = area
		var new_cleaning_power : float = cleaner_ref.collide_with_dirty_spot(self)
		if new_cleaning_power != -1.0:
			start_cleaning(new_cleaning_power)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Cleaner"):
		cleaner_ref = area # por si acaso
		cleaner_ref.stop_colliding_with_dirty_spot(self)

func start_cleaning(new_cleaning_power : float) -> void:
	dirt_left = dirt_left - new_cleaning_power as int
	print("Cleaned once")
	being_cleaned = true
	if dirt_left <= 0:
		being_cleaned = false
		cleaner_ref.finish_cleaning_dirty_spot(self)
		window_ref.on_spot_cleaned()
		queue_free()

func pause_cleaning() -> void:
	being_cleaned = false
