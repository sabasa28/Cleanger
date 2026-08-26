class_name water_bomb
extends Node2D

@export var explotion_time : float
var timer : float = 0.0
var explotion_prefab = preload("res://Scenes/water_explotion.tscn")
var explotion_range : float

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	timer += delta
	if timer >= explotion_time:
		var spawned_explotion = explotion_prefab.instantiate()
		spawned_explotion.range = explotion_range
		spawned_explotion.global_position = global_position
		spawned_explotion.global_scale *= explotion_range 
		add_sibling(spawned_explotion)
		queue_free()
