extends Area2D

@export var collider : CollisionShape2D
const range_base : float = 150.0
var range : float
const time_before_despawn : float = 0.5
var timer : float = 0.0


var origin : Stats.explotion_origin

func _process(delta: float) -> void:
	timer += delta
	if timer >= time_before_despawn:
		queue_free()

func get_range() -> float:
	return range * range_base

func set_data(new_origin : Stats.explotion_origin) -> void:
	origin = new_origin
	match origin:
		Stats.explotion_origin.water_bomb:
			range = Stats.water_bomb_explotion_range
		Stats.explotion_origin.regular_explotion:
			range = Stats.cleaner_explotion_range
			if Stats.cleaner_explotion_water_bomb_chance > 0.0:
				if randf() <= Stats.cleaner_explotion_water_bomb_chance:
					var spawned_bomb = Stats.water_bomb_prefab.instantiate()
					spawned_bomb.global_position = global_position
					add_sibling(spawned_bomb)
					spawned_bomb.initialize()
	scale = Vector2.ONE * range
