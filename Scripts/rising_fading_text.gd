extends RichTextLabel

@export var time_rising : float
@export var random_offset_limit : float
@export var rising_distance : float
var animating_timer : float = 0.0
var animating : bool = false
var spawn_pos : Vector2
var target_pos : Vector2
var transparent_color : Color = Color.TRANSPARENT
var regular_color : Color = Color.BLACK
var text_to_display : String

func _process(delta: float) -> void:
	if animating:
		animating_timer += delta
		if animating_timer >= time_rising:
			visible = false
			animating = false
		else:
			var t = animating_timer / time_rising
			position = lerp(spawn_pos, target_pos, t)
			clear()
			push_color(lerp(regular_color,transparent_color, t))
			add_text(text_to_display)
			pop()

func initialize(number_to_display : String) -> void:
	animating_timer = 0.0
	spawn_pos = Vector2(randf_range(-random_offset_limit,random_offset_limit), randf_range(-random_offset_limit,random_offset_limit))
	position = spawn_pos
	text_to_display = number_to_display
	clear()
	push_color(regular_color)
	add_text(text_to_display)
	pop()
	visible = true
	animating = true
	target_pos = spawn_pos + Vector2.UP * rising_distance
