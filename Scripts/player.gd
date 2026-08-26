class_name Player
extends RigidBody2D

const BASE_strength = 200000.0

var strength_modifier = 1.0
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
var cleaner_rot_speed : float
var unpaused_timer : float
@export var time_to_unpause : float
var waiting_to_unpause : bool = false
var water_bomb_prefab = preload("res://Scenes/water_bomb.tscn")
@export var cleaner_anim : AnimationPlayer
var swipe_anim_cooldown : float
var swipe_anim_timer : float = 0.0
var playing_swipe_anim : bool = false

func _ready() -> void:
	unpaused_timer = time_to_unpause
	Stats.on_rotation_speed_changed.connect(update_rot_speed)
	cleaner_rot_speed = Stats.rotation_speed
	initial_pos = global_position
	last_checked_height = global_position.y
	initial_gravity_scale = gravity_scale
	Objectives.initiate_objective()
	height_checking_timer = height_checking_cooldown
	cleaner.on_stuck_on_spot.connect(start_cleaning_dirty_spot)
	cleaner.on_unstuck_from_spot.connect(stop_cleaning_dirty_spot)
	strength_modifier = Stats.get_strength_modifier()
	swipe_anim_cooldown = cleaner_anim.get_animation("Swipe").length / cleaner_anim.speed_scale
	

func _process(delta: float) -> void:
	if paused:
		if waiting_to_unpause:
			unpaused_timer -= delta
			if unpaused_timer <= 0.0:
				paused = false
		return
	
	swiping = Input.is_action_pressed("clean")
	
	if !is_cleaner_stuck:
		var target_rot : float = cleanerPivot.get_angle_to(get_global_mouse_position())
		cleanerPivot.rotate(lerp(0.0, target_rot, cleaner_rot_speed))
		#cleanerPivot.look_at(get_global_mouse_position())
	cleaner.player_dir = linear_velocity.normalized()
	if swipeCurrentCooldown > 0:
		swipeCurrentCooldown -= delta
	if cleaner.cleaning:
		if cleaning_timer < time_cleaning_after_swipe:
			cleaning_timer += delta
		else:
			cleaner.stop_cleaning()
	
	if swiping:
		if swipeCurrentCooldown <= 0:
			swipeCurrentCooldown = swipeCooldown / Stats.speed_modifier
			cleaner_anim.play("Swipe")
			swipe_anim_timer = swipe_anim_cooldown
			playing_swipe_anim = true
	
	if playing_swipe_anim:
		swipe_anim_timer -= delta
		if swipe_anim_timer <= 0:
			if !cleaner.cleaning:
				cleaner.start_cleaning()
				var spawned_bomb = water_bomb_prefab.instantiate()
				spawned_bomb.global_position = global_position
				spawned_bomb.explotion_range = 1.0
				add_sibling(spawned_bomb)
				spawned_bomb.apply_force(Vector2.UP * BASE_strength)
			if !is_cleaner_stuck: #no cambiar de lugar con el de arriba
				apply_force((cleanerPivot.global_position - cleaner.global_position).normalized() * BASE_strength * strength_modifier)
			playing_swipe_anim = false
			cleaning_timer = 0.0
	
	height_checking_timer -= delta
	if height_checking_timer < 0:
		height_checking_timer = height_checking_cooldown
		Stats.check_height(global_position.y, last_checked_height)
		last_checked_height = global_position.y

func start_cleaning_dirty_spot() -> void:
	linear_velocity *= 0.7

func stop_cleaning_dirty_spot(fully_cleaned_spot : bool) -> void:
	if fully_cleaned_spot:
		Stats.add_dirty_spot_cleaned()

func pause() -> void:
	paused = true
	is_cleaner_stuck = false
	gravity_scale = 0.0
	linear_velocity = Vector2.ZERO

func reset() -> void:
	unpause()
	global_position = initial_pos
	gravity_scale = initial_gravity_scale
	is_cleaner_stuck = false
	swipeCurrentCooldown = 0.0
	strength_modifier = Stats.get_strength_modifier()

func update_rot_speed(new_rot_speed : float) -> void:
	cleaner_rot_speed = new_rot_speed

func unpause() -> void:
	waiting_to_unpause = true
	unpaused_timer = time_to_unpause
