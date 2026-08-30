class_name RisingTextPool
extends Control

var text_pool : Array[Node]
var next_index_to_release : int = 0

func _ready() -> void:
	text_pool.append_array(get_children())

func release_array_element(text_to_show : String) -> void:
	if next_index_to_release >= text_pool.size():
		next_index_to_release = 0
	text_pool[next_index_to_release].initialize(text_to_show)
	next_index_to_release += 1
