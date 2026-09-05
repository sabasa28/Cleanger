class_name water_bomb
extends RigidBody2D

var explotion_time : float
@export var thrown_strength : float
var timer : float = 0.0
var explotion_prefab = preload("res://Scenes/water_explotion.tscn")
var explotion_range : float

func _process(delta: float) -> void:
	timer += delta
	if timer >= explotion_time:
		var spawned_explotion = explotion_prefab.instantiate()
		spawned_explotion.global_position = global_position
		spawned_explotion.set_range(explotion_range) 
		add_sibling(spawned_explotion)
		queue_free()

func initialize() -> void:
	explotion_range = Stats.water_bomb_explotion_range
	explotion_time = randf_range(Stats.water_bomb_explotion_time_min, Stats.water_bomb_explotion_time_max)
	var random_dir : Vector2 = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0)).normalized()
	apply_force(random_dir * thrown_strength)
