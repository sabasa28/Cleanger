class_name Player
extends RigidBody2D

const BASE_STRENGHT = 100000.0

@export var strenght_modifier = 1.0
@export var swipeCooldown = 0.2
var swipeCurrentCooldown = 0.0
var swiping = false
@export var height_checking_cooldown : float
var height_checking_timer = 0.0
@export var time_cleaning_after_swipe = 0.5
var cleaning_timer = 0.0
@export var cleanerPivot : Node2D
@export var cleaner : Cleaner
var is_cleaner_stuck : bool = false
var initial_gravity_scale : float
var last_checked_height : float
var paused : bool = false
var initial_pos : Vector2

func _ready() -> void:
	initial_pos = global_position
	last_checked_height = global_position.y
	initial_gravity_scale = gravity_scale
	Objectives.initiate_objective()
	height_checking_timer = height_checking_cooldown
	cleaner.on_stuck_on_spot.connect(start_cleaning_dirty_spot)
	cleaner.on_unstuck_from_spot.connect(finish_cleaning_dirty_spot)

func _physics_process(delta: float) -> void:
	if swiping:
		if swipeCurrentCooldown <= 0:
			if !is_cleaner_stuck:
				apply_force((global_position - get_global_mouse_position()).normalized() * BASE_STRENGHT * strenght_modifier)
			swipeCurrentCooldown = swipeCooldown
			cleaner.start_cleaning()
			cleaning_timer = 0.0

func _process(delta: float) -> void:
	if paused:
		return
	#print(Engine.get_frames_per_second())
	
	swiping = Input.is_action_pressed("clean")
	
	if !is_cleaner_stuck:
		cleanerPivot.look_at(get_global_mouse_position())
	cleaner.player_dir = linear_velocity.normalized()
	if swipeCurrentCooldown > 0:
		swipeCurrentCooldown -= delta
	if cleaner.cleaning:
		if cleaning_timer < time_cleaning_after_swipe:
			cleaning_timer += delta
		else:
			cleaner.cleaning = false
	
	height_checking_timer -= delta
	if height_checking_timer < 0:
		height_checking_timer = height_checking_cooldown
		Stats.check_height(global_position.y, last_checked_height)
		last_checked_height = global_position.y

func start_cleaning_dirty_spot() -> void:
	is_cleaner_stuck = true
	linear_velocity = Vector2.ZERO
	gravity_scale = 0.0

func finish_cleaning_dirty_spot() -> void:
	is_cleaner_stuck = false
	gravity_scale = initial_gravity_scale
	swipeCurrentCooldown = 0.0
	Stats.add_dirty_spot_cleaned()

func pause() -> void:
	paused = true
	is_cleaner_stuck = false
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO

func reset() -> void:
	paused = false
	global_position = initial_pos
	gravity_scale = initial_gravity_scale
	is_cleaner_stuck = false
	swipeCurrentCooldown = 0.0
	
