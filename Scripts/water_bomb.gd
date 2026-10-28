class_name water_bomb
extends RigidBody2D

var explotion_time : float
@export var thrown_strength : float
var timer : float = 0.0
var is_super_bomb : bool = false
@export var sprite : Sprite2D

func _process(delta: float) -> void:
	print("WATER BOMB SCALE: ", global_scale)
	timer += delta
	if timer >= explotion_time:
		var spawned_explotion = Stats.explotion_prefab.instantiate()
		spawned_explotion.global_position = global_position
		var will_instaclean = false
		if Stats.water_bomb_instant_clean_unlocked:
			if randf() < Stats.water_bomb_instant_clean_chance:
				will_instaclean = true
		spawned_explotion.set_data(Stats.explotion_origin.super_water_bomb if is_super_bomb else Stats.explotion_origin.water_bomb, will_instaclean)
		add_sibling(spawned_explotion)
		queue_free()

func initialize(is_clone : bool = false, new_is_super_bomb : bool = false) -> void:
	is_super_bomb = new_is_super_bomb
	if is_super_bomb:
		initialize_super_bomb()
		return
	explotion_time = randf_range(Stats.water_bomb_explotion_time_min, Stats.water_bomb_explotion_time_max)
	var random_dir : Vector2 = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,0.0)).normalized()
	apply_force(random_dir * thrown_strength)
	if !is_clone && Stats.water_bomb_water_bomb_chance > 0.0:
			if randf() < Stats.water_bomb_water_bomb_chance:
				var spawned_bomb = Stats.water_bomb_prefab.instantiate()
				spawned_bomb.global_position = global_position
				get_parent().add_sibling(spawned_bomb) #????
				spawned_bomb.initialize(true)

func initialize_super_bomb() -> void:
	explotion_time = Stats.water_bomb_explotion_time_max
	var dir : Vector2 = Vector2.UP
	sprite.scale *= 3.0
	apply_force(dir * thrown_strength)
