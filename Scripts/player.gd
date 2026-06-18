extends RigidBody2D

const BASE_STRENGHT = 100000.0

@export var strenght_modifier = 1.0
@export var swipeCooldown = 0.2
var swipeCurrentCooldown = 0.0
var cleaning = false
@export var cleanerPivot : Node2D
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if cleaning:
		if swipeCurrentCooldown <= 0:
			apply_force((global_position - get_global_mouse_position()).normalized() * BASE_STRENGHT * strenght_modifier)
			swipeCurrentCooldown = swipeCooldown
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cleaning = Input.is_action_pressed("clean")
	if cleaning:
		cleanerPivot.look_at(get_global_mouse_position())
	if swipeCurrentCooldown > 0:
		swipeCurrentCooldown -= delta
