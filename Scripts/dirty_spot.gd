extends Node2D

var being_cleaned : bool = false

var cleaning_timer : float
var cleaner_ref

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !being_cleaned:
		return
	cleaning_timer -= delta
	if cleaning_timer <= 0.0:
		being_cleaned = false
		cleaner_ref.finish_cleaning_dirty_spot()
		queue_free()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if being_cleaned:
		return
	if area.is_in_group("Cleaner"):
		cleaner_ref = area
		cleaning_timer = cleaner_ref.start_cleaning_dirty_spot()
		being_cleaned = true
