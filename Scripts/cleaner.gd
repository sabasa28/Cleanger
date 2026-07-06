class_name Cleaner
extends Area2D

enum direction { up , down, left, right}

class mediatrix_data:
	var cornerH1V1 : Vector2
	var cornerH1V2 : Vector2
	var cornerH2V1 : Vector2
	var cornerH2V2 : Vector2
	var last_cornerH1V1 : Vector2
	var last_cornerH1V2 : Vector2
	var last_cornerH2V1 : Vector2
	var last_cornerH2V2 : Vector2
	var up : Vector2
	var down : Vector2
	var right : Vector2
	var left : Vector2
	var last_up : Vector2
	var last_down : Vector2
	var last_right : Vector2
	var last_left : Vector2
	var cleaner_dir : direction

var current_mediatrix_data : mediatrix_data
@export var collider : CollisionShape2D
var cleaning = false
var first_frame_cleaning = false
var last_pos : Vector2
var curr_pos : Vector2
var player_dir : Vector2
var mediatrix_data_updated : bool

func _ready() -> void:
	collider = get_node("CollisionShape2D")
	current_mediatrix_data = mediatrix_data.new()
	get_mediatrix_data()

func _process(delta: float) -> void:
	mediatrix_data_updated = false
	last_pos = global_position
	curr_pos = global_position
	if cleaning:
		first_frame_cleaning = false
		#set_cleaner_dir()

func get_mediatrix_data() -> mediatrix_data: 
	if mediatrix_data_updated:
		return current_mediatrix_data
	var forward_vec = Vector2(global_transform.y).normalized() #eventualmente
	var up_vec = Vector2(forward_vec.y, -forward_vec.x) 								#arreglar
	
	current_mediatrix_data.last_cornerH1V1 = current_mediatrix_data.cornerH1V1
	current_mediatrix_data.last_cornerH1V2 = current_mediatrix_data.cornerH1V2
	current_mediatrix_data.last_cornerH2V1 = current_mediatrix_data.cornerH2V1
	current_mediatrix_data.last_cornerH2V2 = current_mediatrix_data.cornerH2V2
	
	var mediatrixV1 = position - forward_vec * ((collider.shape.get_rect().size.y * global_scale.y) / 2.0)
	var mediatrixV2 = position + forward_vec * ((collider.shape.get_rect().size.y * global_scale.y) / 2.0)
	var mediatrixH1 = position + up_vec * ((collider.shape.get_rect().size.x * global_scale.x) / 2.0)
	var mediatrixH2 = position - up_vec * ((collider.shape.get_rect().size.x * global_scale.x) / 2.0)
	
	#print("fw: ", forward_vec)
	#print("up: ", up_vec)
	#print("H1: ", mediatrixH1)
	#print("H2: ", mediatrixH2)
	#print("V1: ", mediatrixV1)
	#print("V2: ", mediatrixV2)
	
	current_mediatrix_data.last_up = current_mediatrix_data.up      #esto funciona por el if de arriba que asegura
	current_mediatrix_data.last_down = current_mediatrix_data.down  #que solo se updatee una vez por frame
	current_mediatrix_data.last_right = current_mediatrix_data.right
	current_mediatrix_data.last_left = current_mediatrix_data.left
	current_mediatrix_data.up = mediatrixV2 - mediatrixV1
	current_mediatrix_data.down = -current_mediatrix_data.up
	current_mediatrix_data.right = mediatrixH1 - mediatrixH2
	current_mediatrix_data.left = -current_mediatrix_data.right
	
	current_mediatrix_data.cornerH1V1 = mediatrixH1 - current_mediatrix_data.up / 2.0 #cambiar esto para no calcular las mediatrices
	current_mediatrix_data.cornerH1V2 = mediatrixH1 + current_mediatrix_data.up / 2.0 #, en vez de eso calcular las esquinas directamente
	current_mediatrix_data.cornerH2V1 = mediatrixH2 - current_mediatrix_data.up / 2.0
	current_mediatrix_data.cornerH2V2 = mediatrixH2 + current_mediatrix_data.up / 2.0
	
	
	mediatrix_data_updated = true
	return current_mediatrix_data

#func set_cleaner_dir() -> void:
	#current_mediatrix_data.cleaner_dir = direction.up
	#var highest_dot_product = player_dir.dot(current_mediatrix_data.up)
	#var aux = player_dir.dot(current_mediatrix_data.down)
	#if highest_dot_product < aux:
		#highest_dot_product = aux
		#current_mediatrix_data.cleaner_dir = direction.down
	#aux = player_dir.dot(current_mediatrix_data.right)
	#if highest_dot_product < aux:
		#highest_dot_product = aux
		#current_mediatrix_data.cleaner_dir = direction.right
	#aux = player_dir.dot(current_mediatrix_data.left)
	#if highest_dot_product < aux:
		#highest_dot_product = aux
		#current_mediatrix_data.cleaner_dir = direction.left	

func start_cleaning() -> void:
	cleaning = true
	first_frame_cleaning = true
	#set_cleaner_dir()
	get_mediatrix_data()
