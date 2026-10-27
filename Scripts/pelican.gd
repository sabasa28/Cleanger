extends Node2D

@export var flying_speed : float
@export var animator : AnimationPlayer
@export var sprite : Sprite2D
var direction : int = 1
var distance_before_despawn : float
var spawn_x : float
var stun_time : float = 3.0
var is_water_pelican : bool = false
var is_persistent_pelican : bool = false
@export var fade_time : float
var fade_timer : float = 0.0
var fading_in : bool = true
var fading_out : bool = false

func _ready() -> void:
	sprite.modulate.a = 0.0

func initialize(going_right : bool, new_distance_before_despawn: float, new_is_water_pelican : bool, new_is_peristent_pelican : bool) -> void:
	if going_right:
		direction = 1
		sprite.flip_h = true
	else:
		direction = -1
	spawn_x = global_position.x
	distance_before_despawn = new_distance_before_despawn
	is_water_pelican = new_is_water_pelican
	is_persistent_pelican = new_is_peristent_pelican
	animator.play("Flying")
	if  is_water_pelican:
		sprite.region_rect.position.x = 96.0

func _process(delta: float) -> void:
	if fading_in:
		fade_timer += delta
		sprite.modulate.a = fade_timer / fade_time
		if fade_timer > fade_time:
			fading_in = false
			fade_timer = 0.0
	if fading_out:
		fade_timer += delta
		sprite.modulate.a = 1.0 - fade_timer / fade_time
		if fade_timer > fade_time:
			fading_out = false
			queue_free()
			return
	global_position.x += direction * flying_speed * delta
	if !fading_out && abs(spawn_x - global_position.x) > distance_before_despawn:
		if is_persistent_pelican:
			turn_around()
		else:
			fading_out = true

func turn_around() -> void:
	direction = -direction
	sprite.flip_h = (direction == 1)
	spawn_x = global_position.x

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		area.get_reference().stun(stun_time)
		if is_water_pelican:
				var spawned_explotion = Stats.explotion_prefab.instantiate()
				spawned_explotion.global_position = global_position
				add_sibling(spawned_explotion)
				spawned_explotion.set_data(Stats.explotion_origin.regular_explotion)
		queue_free()
