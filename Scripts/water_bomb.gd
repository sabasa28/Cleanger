class_name water_bomb
extends RigidBody2D

var explotion_time : float
@export var thrown_strength : float
var timer : float = 0.0

func _process(delta: float) -> void:
	timer += delta
	if timer >= explotion_time:
		var spawned_explotion = Stats.explotion_prefab.instantiate()
		spawned_explotion.global_position = global_position
		spawned_explotion.set_data(Stats.explotion_origin.water_bomb)
		add_sibling(spawned_explotion)
		queue_free()

func initialize(is_clone : bool = false) -> void:
	explotion_time = randf_range(Stats.water_bomb_explotion_time_min, Stats.water_bomb_explotion_time_max)
	var random_dir : Vector2 = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0)).normalized()
	apply_force(random_dir * thrown_strength)
	if !is_clone && Stats.water_bomb_water_bomb_chance > 0.0:
			if randf() > Stats.water_bomb_water_bomb_chance:
				var spawned_bomb = Stats.water_bomb_prefab.instantiate()
				spawned_bomb.global_position = global_position
				get_parent().add_sibling(spawned_bomb)
				spawned_bomb.initialize(true)
