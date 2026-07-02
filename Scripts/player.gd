extends RigidBody2D

const BASE_STRENGHT = 100000.0

@export var strenght_modifier = 1.0
@export var swipeCooldown = 0.2
var swipeCurrentCooldown = 0.0
var swiping = false
const time_cleaning_after_swipe = 0.5
var cleaning_timer = 0.0
@export var cleanerPivot : Node2D
@export var cleaner : Cleaner

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if swiping:
		if swipeCurrentCooldown <= 0:
			apply_force((global_position - get_global_mouse_position()).normalized() * BASE_STRENGHT * strenght_modifier)
			swipeCurrentCooldown = swipeCooldown
			cleaner.start_cleaning()
			cleaning_timer = 0.0

func _process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	swiping = Input.is_action_pressed("clean")
	if swiping:
		cleanerPivot.look_at(get_global_mouse_position())
		cleaner.player_dir = linear_velocity.normalized()
	if swipeCurrentCooldown > 0:
		swipeCurrentCooldown -= delta
	if cleaner.cleaning:
		if cleaning_timer < time_cleaning_after_swipe:
			cleaning_timer += delta
		else:
			cleaner.cleaning = false
