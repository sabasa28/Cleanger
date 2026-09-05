extends Area2D

@export var collider : CollisionShape2D
const range_base : float = 150.0
var range : float
const time_before_despawn : float = 0.5
var timer : float = 0.0

func _process(delta: float) -> void:
	timer += delta
	if timer >= time_before_despawn:
		queue_free()

func get_range() -> float:
	return range * range_base

func set_range(new_range : float) -> void:
	range = new_range
	scale = Vector2.ONE * range
