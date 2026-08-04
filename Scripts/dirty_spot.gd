extends Node2D

var being_cleaned : bool = false

var cleaning_timer : float
var half_cleaning_time : float
var dirt_left : float = 1.0
var cleaner_ref
var is_half_cleaned : bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !being_cleaned:
		return
	cleaning_timer -= delta
	if !is_half_cleaned && cleaning_timer < half_cleaning_time:
		print("cambiamos el sprite a uno a medio limpiar")
		is_half_cleaned = true
	
	if cleaning_timer <= 0.0:
		being_cleaned = false
		cleaner_ref.finish_cleaning_dirty_spot(self)
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if being_cleaned:
		return
	if area.is_in_group("Cleaner"):
		cleaner_ref = area
		var new_cleaning_time : float = cleaner_ref.collide_with_dirty_spot(self)
		if new_cleaning_time != -1.0:
			start_cleaning(new_cleaning_time)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Cleaner"):
		cleaner_ref = area # por si acaso
		cleaner_ref.stop_colliding_with_dirty_spot(self)

func start_cleaning(new_cleaning_time : float) -> void:
	half_cleaning_time = new_cleaning_time / 2.0
	print("start cleaning")
	cleaning_timer = new_cleaning_time * dirt_left
	being_cleaned = true

func pause_cleaning() -> void:
	being_cleaned = false
	dirt_left = cleaning_timer / (half_cleaning_time * 2.0)
