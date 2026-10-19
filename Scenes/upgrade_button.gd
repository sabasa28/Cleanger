extends "res://Scripts/masked_button.gd"
class_name upgrade_button

@export var offset_position : Array[Vector2] = [Vector2(0.0, 0.0)]
@export var bought_texture : Texture2D
var current_offset = 0
var initial_pos : Vector2
@export var on_unlocked_raise_offset_of : Array[upgrade_button]
@export var on_bought_raise_offset_of : Array[upgrade_button]
@export var on_maxed_raise_offset_of : Array[upgrade_button]
var description_displayer : Node

func _ready() -> void:
	super._ready()
	initial_pos = global_position
	disabled = true
	description_displayer = get_child(0)
	mouse_entered.connect(_display_description)
	mouse_exited.connect(_stop_displaying_description)

func _process(delta: float) -> void:
	pass

func on_unlock() -> void:
	disabled = false
	for i in on_unlocked_raise_offset_of:
		i.raise_offset_index()

func on_maxed() -> void:
	for i in on_maxed_raise_offset_of:
		i.raise_offset_index()

func on_bought() -> void: # bought == first level or higher
	texture_normal = bought_texture
	for i in on_bought_raise_offset_of:
		i.raise_offset_index()

func raise_offset_index() -> void:
	current_offset+= 1
	if current_offset < offset_position.size():
		global_position = initial_pos + offset_position[current_offset]

func _display_description() -> void:
	if description_displayer.enabled:
		description_displayer.visible = true

func _stop_displaying_description() -> void:
	description_displayer.visible = false
