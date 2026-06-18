class_name Cleaner
extends Area2D

class mediatrix_data:
	var mediatrixV1 : Vector2
	var mediatrixV2 : Vector2
	var mediatrixH1 : Vector2
	var mediatrixH2 : Vector2


var current_mediatrix_data : mediatrix_data
@export var collider : CollisionShape2D


func _ready() -> void:
	collider = get_node("CollisionShape2D")
	current_mediatrix_data = mediatrix_data.new()
	get_mediatrix_data()

func _process(delta: float) -> void:
	get_mediatrix_data()

func get_mediatrix_data() -> mediatrix_data: 
	var forward_vec = Vector2(global_transform.y.x, -global_transform.y.y).normalized()
	var up_vec = Vector2(forward_vec.y, -forward_vec.x) 
	current_mediatrix_data.mediatrixV1 = position - forward_vec * ((collider.shape.get_rect().size.y * global_scale.y) / 2)
	current_mediatrix_data.mediatrixV2 = position + forward_vec * ((collider.shape.get_rect().size.y * global_scale.y) / 2)
	current_mediatrix_data.mediatrixH1 = position + up_vec * ((collider.shape.get_rect().size.x * global_scale.x) / 2)
	current_mediatrix_data.mediatrixH2 = position - up_vec * ((collider.shape.get_rect().size.x * global_scale.x) / 2)
	#print("H1: ", current_mediatrix_data.mediatrixH1)
	#print("H2: ", current_mediatrix_data.mediatrixH2)
	#print("V1: ", current_mediatrix_data.mediatrixV1)
	#print("V2: ", current_mediatrix_data.mediatrixV2)
	return current_mediatrix_data
