extends Sprite2D

@export var image_size := Vector2i(128,170)
@export var brush_size := 60
@export var collision : CollisionShape2D
var body_inside : Array[Node2D]
var image : Image
var initialImage : Image
@export var textureToPutOver : Texture2D
@export var textureForMask : Texture2D
var imageToPutOver : Image
var imageToPutOverMask : Image
var super_pixels_interval : Vector2i
var super_pixels_state : Array[bool]
var super_pixels_cleaned : int
var min_super_pixels_to_clear : int
@export var amount_of_window_before_fullclean : float
@export var super_pixels_per_side : int
var half_super_pixels_per_side : int
var cleaned = false

class limit:
	var pos : Vector2
	var dot : float

var aux_limits : Array[limit]

func _ready() -> void:
	aux_limits.resize(4)
	for i in aux_limits.size():
		aux_limits[i] = limit.new()
	super_pixels_cleaned = 0
	min_super_pixels_to_clear = (super_pixels_per_side * super_pixels_per_side) * amount_of_window_before_fullclean
	super_pixels_state.resize(super_pixels_per_side * super_pixels_per_side)
	super_pixels_interval = image_size / super_pixels_per_side
	half_super_pixels_per_side = super_pixels_per_side / 2
	texture = ImageTexture.create_from_image(Image.create_empty(image_size.x,image_size.y,false, Image.FORMAT_RGBA8))
	imageToPutOver = textureForMask.get_image()
	imageToPutOver.resize(image_size.x, image_size.y)
	image = texture.get_image()
	image.blend_rect(imageToPutOver, Rect2i(0,0,image_size.x,image_size.y),Vector2i(0,0))
	initialImage = Image.create_empty(image_size.x, image_size.y, false, Image.FORMAT_RGBA8)
	initialImage.copy_from(image)
	image.fill(Color.SADDLE_BROWN)
	#image.fill_rect(Rect2i(5,5,20,20),Color.RED)
	texture.set_image(image)
	var comparisonDict = image.compute_image_metrics(initialImage, false)
	#print(comparisonDict.get("max"))
	#print(comparisonDict.get("mean"))
	#print(comparisonDict.get("mean_squared"))
	#print(comparisonDict.get("root_mean_squared"))
	#print(comparisonDict.get("peak_snr"))
	collision.scale = Vector2(image_size.x / 20.0, image_size.y /20.0)

func _paint_texture(pos: Vector2, body : Node2D) -> void:
	var mediatrix_data : Cleaner.mediatrix_data = body.get_mediatrix_data()
	var up = Vector2 (mediatrix_data.up.x, mediatrix_data.up.y)
	var down = Vector2 (mediatrix_data.down.x, mediatrix_data.down.y)
	var right = Vector2 (mediatrix_data.right.x, mediatrix_data.right.y)
	var left = Vector2 (mediatrix_data.left.x, mediatrix_data.left.y)
	
	var up_limit = pos - up / 2.0
	var down_limit = pos - down / 2.0
	var right_limit = pos - right / 2.0
	var left_limit = pos - left / 2.0
	#ESTO PODRIA SER 2 ESQUINAS EN VEZ DE 4 LADOS
	
	#var interp_up 
	#var interp_down 
	#var interp_left
	#var interp_right 
	var body_globalpos = body.global_position
	var pos_test : Vector2 = body.curr_pos - global_position - offset + get_rect().size/2.0
	var poss_test : Vector2 = body.global_position - global_position - offset + get_rect().size/2.0
	var last_pos : Vector2 = body.last_pos - global_position - offset + get_rect().size/2.0 #puede ponerse en una variable en el cleaner probly
	var pos_frame_delta = (pos - last_pos).normalized()
	
	var limit1_options : Array[limit]
	var limit2_options : Array[limit]
	
	var limit1_curr : Vector2
	var limit2_curr : Vector2
	var limit1_prev : Vector2
	var limit2_prev : Vector2
	
	var dir1 : Vector2
	var dir2 : Vector2
	var dir3 : Vector2
	var dir4 : Vector2
	
	var curr_mediatrix0 : Vector2
	var curr_mediatrix1 : Vector2
	var curr_mediatrix2 : Vector2
	var curr_mediatrix3 : Vector2
	
	if !body.first_frame_cleaning and pos != last_pos:
		var side_checker_dir = (pos - last_pos).normalized()
		side_checker_dir = Vector2(side_checker_dir.y, -side_checker_dir.x)
		
		aux_limits[0].pos = pos + mediatrix_data.cornerH1V1
		aux_limits[1].pos = pos + mediatrix_data.cornerH1V2
		aux_limits[2].pos = pos + mediatrix_data.cornerH2V1
		aux_limits[3].pos = pos + mediatrix_data.cornerH2V2
		curr_mediatrix0 = aux_limits[0].pos
		curr_mediatrix1 = aux_limits[1].pos
		curr_mediatrix2 = aux_limits[2].pos
		curr_mediatrix3 = aux_limits[3].pos
		
		
		#image.fill_rect(Rect2i(aux_limits[0].pos, super_pixels_interval), Color.DEEP_PINK)
		#image.fill_rect(Rect2i(aux_limits[1].pos, super_pixels_interval), Color.DEEP_PINK)
		#image.fill_rect(Rect2i(aux_limits[2].pos, super_pixels_interval), Color.DEEP_PINK)
		#image.fill_rect(Rect2i(aux_limits[3].pos, super_pixels_interval), Color.DEEP_PINK)
		
		
		for i in aux_limits.size(): #ASEGURARSE DE QUE HAYAN 2 COSAS EN CADA LIMITE
			aux_limits[i].dot = pos_frame_delta.dot(aux_limits[i].pos - last_pos)
			if is_point_in_front(aux_limits[i].pos, side_checker_dir, last_pos):
				limit1_options.append(aux_limits[i])
			else:
				limit2_options.append(aux_limits[i])
		
		limit1_curr = limit1_options[0].pos if limit1_options[0].dot < limit1_options[1].dot else limit1_options[1].pos
		limit2_curr = limit2_options[0].pos if limit2_options[0].dot < limit2_options[1].dot else limit2_options[1].pos
		
		print("limit curr 1", limit1_curr)
		print("limit curr 2", limit2_curr)
		
		limit1_options.clear()
		limit2_options.clear()
		
		pos_frame_delta = -pos_frame_delta
		aux_limits[0].pos = last_pos + mediatrix_data.last_cornerH1V1
		aux_limits[1].pos = last_pos + mediatrix_data.last_cornerH1V2
		aux_limits[2].pos = last_pos + mediatrix_data.last_cornerH2V1
		aux_limits[3].pos = last_pos + mediatrix_data.last_cornerH2V2
		
		for i in aux_limits.size(): #ASEGURARSE DE QUE HAYAN 2 COSAS EN CADA LIMITE
			aux_limits[i].dot = pos_frame_delta.dot(aux_limits[i].pos - pos)
			if is_point_in_front(aux_limits[i].pos, side_checker_dir, pos): #deberia ser lo mismo last_pos y pos porque estan en la misma linea
				limit1_options.append(aux_limits[i])
			else:
				limit2_options.append(aux_limits[i])
		
		limit1_prev = limit1_options[0].pos if limit1_options[0].dot < limit1_options[1].dot else limit1_options[1].pos
		limit2_prev = limit2_options[0].pos if limit2_options[0].dot < limit2_options[1].dot else limit2_options[1].pos
		
		print("limit prev 1", limit1_prev)
		print("limit prev 2", limit2_prev)
		print("-")
		
		dir1 = (limit1_curr - limit1_prev).normalized()
		dir1 = Vector2(-dir1.y, dir1.x)
		dir2 = (limit2_curr - limit2_prev).normalized()
		dir2 = Vector2(dir2.y, -dir2.x)
		dir3 = (limit1_curr - limit2_curr).normalized()
		dir3 = Vector2(-dir3.y, dir3.x)
		dir4 = (limit1_prev - limit2_prev).normalized()
		dir4 = Vector2(dir4.y, -dir4.x)
		if (pos_frame_delta.dot(dir3) < 0): #necesario o podria invertirlos de una? minimo que empiecen al reves e invertir la condicion
			dir3 = -dir3
			dir4 = -dir4
		print("dir 1", dir1)
		print("dir 2", dir2)
		print("dir 3", dir3)
		print("dir 4", dir4)
		
		#image.fill_rect(Rect2i(limit1_curr, super_pixels_interval), Color.YELLOW)
		#image.fill_rect(Rect2i(limit2_curr, super_pixels_interval), Color.YELLOW)
		#image.fill_rect(Rect2i(limit1_prev, super_pixels_interval), Color.GREEN)
		#image.fill_rect(Rect2i(limit2_prev, super_pixels_interval), Color.GREEN)
		#image.fill_rect(Rect2i(pos, super_pixels_interval), Color.YELLOW)
		#image.fill_rect(Rect2i(last_pos, super_pixels_interval), Color.GREEN)
		
	for columna in super_pixels_per_side:
		for fila in super_pixels_per_side:
			var super_pixel_num = columna * super_pixels_per_side + fila
			if super_pixels_state[super_pixel_num] == true:
				continue
			if is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y),up, up_limit) && \
			is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y),down, down_limit) && \
			is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y), right, right_limit) && \
			is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y), left, left_limit):
				image.fill_rect(Rect2i(fila * super_pixels_interval.x, columna * super_pixels_interval.y,super_pixels_interval.x,super_pixels_interval.y), Color.LIGHT_BLUE)
				super_pixels_state.set(super_pixel_num, true)
				super_pixels_cleaned += 1
				if super_pixels_cleaned > min_super_pixels_to_clear:
					image.fill(Color.LIGHT_BLUE)
					cleaned = true
					break
				continue
			
			if body.first_frame_cleaning or pos == last_pos:
				continue
			
			#ACA CAMBIAR LOS LIMITES SEGUN LA DIR, EL LADO DE ENFRENTE DEL FRAME PASADO Y EL DE ATRAS DEL ACTUAL
			if is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y), dir3, limit1_curr):
				if is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y), dir4, limit1_prev):
					if is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y), dir1, limit1_prev):
						if is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y), dir2, limit2_prev):
							image.fill_rect(Rect2i(fila * super_pixels_interval.x, columna * super_pixels_interval.y,super_pixels_interval.x,super_pixels_interval.y), Color.LIGHT_BLUE)
							super_pixels_state.set(super_pixel_num, true)
							super_pixels_cleaned += 1
							if super_pixels_cleaned > min_super_pixels_to_clear:
								image.fill(Color.LIGHT_BLUE)
								cleaned = true
								break
		if cleaned:
			break
		
	#image.fill_rect(Rect2i(pos.x,pos.y,brush_size,brush_size), Color.LIGHT_BLUE)
	#image.fill_rect(Rect2i(pos.x,pos.y ,brush_size,brush_size), Color.LIGHT_BLUE)
	#image.fill_rect(Rect2i(pos + Vector2(up.normalized().x, -up.normalized().y) * 100, Vector2(brush_size,brush_size)), Color.LIGHT_BLUE)
	texture.update(image)

func is_point_in_front(point : Vector2, dir : Vector2, orig : Vector2) -> bool:
	return dir.dot((point - orig).normalized()) > 0

func _paint_zone(v_normal1 : Vector2, v_normal2 : Vector2, h_normal1 : Vector2, h_normal2 : Vector2) -> void:
	pass

func _process(delta: float) -> void:
	if cleaned:
		return
	for i in body_inside:
		if i.cleaning == true:
			var pos = i.global_position - global_position - offset + get_rect().size/2.0
			_paint_texture(pos, i)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if cleaned:
		return
	if area.is_in_group("Cleaner"):
		body_inside.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if cleaned:
		return
	if area.is_in_group("Cleaner"):
		body_inside.remove_at(body_inside.find(area))
