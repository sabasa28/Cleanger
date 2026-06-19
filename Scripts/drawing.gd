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
@export var super_pixels_per_side : int
var half_super_pixels_per_side : int


func _ready() -> void:
	super_pixels_interval = image_size / super_pixels_per_side
	half_super_pixels_per_side = super_pixels_per_side / 2
	texture = ImageTexture.create_from_image(Image.create_empty(image_size.x,image_size.y,false, Image.FORMAT_RGBA8))
	imageToPutOver = textureForMask.get_image()
	imageToPutOver.resize(image_size.x, image_size.y)
	image = texture.get_image()
	image.blend_rect(imageToPutOver, Rect2i(0,0,image_size.x,image_size.y),Vector2i(0,0))
	initialImage = Image.create_empty(image_size.x, image_size.y, false, Image.FORMAT_RGBA8)
	initialImage.copy_from(image)
	image.fill(Color.BLUE)
	image.fill_rect(Rect2i(5,5,20,20),Color.RED)
	texture.set_image(image)
	var comparisonDict = image.compute_image_metrics(initialImage, false)
	print(comparisonDict.get("max"))
	print(comparisonDict.get("mean"))
	print(comparisonDict.get("mean_squared"))
	print(comparisonDict.get("root_mean_squared"))
	print(comparisonDict.get("peak_snr"))
	collision.scale = Vector2(image_size.x / 20.0, image_size.y /20.0)

func _paint_texture(pos: Vector2, body : Node2D) -> void:
	var mediatrix_data : Cleaner.mediatrix_data = body.get_mediatrix_data()
	var up = mediatrix_data.mediatrixV2 - mediatrix_data.mediatrixV1
	var down = -up
	var right = mediatrix_data.mediatrixH1 - mediatrix_data.mediatrixH2
	var left = -right
	#print ("right ",right.normalized())
	#print ("left ",left.normalized())
	#print ("up ",up.normalized())
	#print ("down ",down.normalized())
	print("pos", pos)
	print(body.global_position)

	#if is_point_in_front(Vector2(I * super_pixels_interval.x, J * super_pixels_interval.y), up, pos - up.normalized() * 20):	
	for columna in super_pixels_per_side:
		for fila in super_pixels_per_side:
			if is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y),Vector2(up.x, -up.y), pos - Vector2(up.x, -up.y) / 2.0) && \
			is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y),Vector2(down.x, -down.y), pos - Vector2(down.x, -down.y) / 2.0) && \
			is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y),Vector2(right.x, -right.y), pos - Vector2(right.x, -right.y) / 2.0) && \
			is_point_in_front(Vector2(fila * super_pixels_interval.x, columna * super_pixels_interval.y),Vector2(left.x, -left.y), pos - Vector2(left.x, -left.y) / 2.0):
				image.fill_rect(Rect2i(fila * super_pixels_interval.x, columna * super_pixels_interval.y,super_pixels_interval.x,super_pixels_interval.y), Color.LIGHT_BLUE)
			#if up.dot(Vector2(fila, columna) - mediatrix_data.mediatrixV1)
	#image.fill_rect(Rect2i(pos.x,pos.y,brush_size,brush_size), Color.LIGHT_BLUE)
	#image.fill_rect(Rect2i(pos.x,pos.y ,brush_size,brush_size), Color.LIGHT_BLUE)
	#image.fill_rect(Rect2i(pos + Vector2(up.normalized().x, -up.normalized().y) * 100, Vector2(brush_size,brush_size)), Color.LIGHT_BLUE)
	texture.update(image)

func is_point_in_front(point : Vector2, dir : Vector2, orig : Vector2) -> bool:
	return dir.dot((point - orig).normalized()) > 0

func _paint_zone(v_normal1 : Vector2, v_normal2 : Vector2, h_normal1 : Vector2, h_normal2 : Vector2) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cleaner"):
		body_inside.append(body)
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Cleaner"):
		body_inside.remove_at(body_inside.find(body))

func _process(delta: float) -> void:
	for i in body_inside:
		var pos = i.global_position - global_position - offset + get_rect().size/2.0
		_paint_texture(pos, i)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Cleaner"):
		body_inside.append(area)
		print("adsfasdfs")

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Cleaner"):
		body_inside.remove_at(body_inside.find(area))
