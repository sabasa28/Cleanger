extends Node2D

@export var flying_speed : float
var direction : int = 1
var distance_before_despawn : float
var spawn_x : float
var stun_time : float = 3.0
func _ready() -> void:
	pass

func initialize(going_right : bool, new_distance_before_despawn: float) -> void:
	direction = 1 if going_right else -1
	spawn_x = global_position.x
	distance_before_despawn = new_distance_before_despawn

func _process(delta: float) -> void:
	global_position.x += direction * flying_speed * delta
	if abs(spawn_x - global_position.x) > distance_before_despawn:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.stun(stun_time)
		queue_free()
