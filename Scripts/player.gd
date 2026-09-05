class_name Player
extends RigidBody2D

const BASE_strength = 200000.0

var strength_modifier = 1.0
@export var swipe_base_cooldown : float
var swipe_modified_cooldown
var swipe_current_cooldown = 0.0
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
	swipe_modified_cooldown = swipe_base_cooldown / Stats.speed_modifier
	unpaused_timer = time_to_unpause
	Stats.on_rotation_speed_changed.connect(update_rot_speed)
	Stats.on_speed_modified.connect(raise_cleaner_speed_level)
	Stats.on_width_modified.connect(raise_cleaner_width_level)
	cleaner_rot_speed = Stats.rotation_speed
	initial_pos = global_position
	last_checked_height = global_position.y
	initial_gravity_scale = gravity_scale
	Objectives.initiate_objective()
	height_checking_timer = height_checking_cooldown
	cleaner.on_stuck_on_spot.connect(start_cleaning_dirty_spot)
	strength_modifier = Stats.get_strength_modifier()
	swipe_anim_cooldown = cleaner_anim.get_animation("Swipe").length / cleaner_anim.speed_scale / 2.0 #CHECKEAR QUE NO SEA MAS LENTO ESTE CD QUE EL DEL SWIPE_COOLDOWN MEJORADO


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
	if swipe_current_cooldown > 0:
		swipe_current_cooldown -= delta
	if cleaner.cleaning:
		if cleaning_timer < time_cleaning_after_swipe:
			cleaning_timer += delta
		else:
			cleaner.stop_cleaning()
	
	if swiping:
		if swipe_current_cooldown <= 0:
			swipe_current_cooldown = swipe_base_cooldown / Stats.speed_modifier
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
				add_sibling(spawned_bomb)
				spawned_bomb.initialize()
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
	swipe_current_cooldown = 0.0
	strength_modifier = Stats.get_strength_modifier()

func update_rot_speed(new_rot_speed : float) -> void:
	cleaner_rot_speed = new_rot_speed

func unpause() -> void:
	waiting_to_unpause = true
	unpaused_timer = time_to_unpause

func raise_cleaner_speed_level(new_speed_modifier : float, new_speed_level : int) -> void:
	swipe_modified_cooldown = swipe_base_cooldown / new_speed_modifier
	cleaner.set_cleaner_speed_sprite(new_speed_level)

func raise_cleaner_width_level(new_width_level : int) -> void:
	cleaner.set_width(new_width_level)
