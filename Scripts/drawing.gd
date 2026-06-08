extends Sprite2D

@export var image_size := Vector2i(128,170)
@export var brush_size := 60
@export var collision : CollisionShape2D
var body_inside : Array[Node2D]
var image : Image

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = ImageTexture.create_from_image(Image.create_empty(image_size.x,image_size.y,false, Image.FORMAT_RGBA8))
	image = texture.get_image()
	image.fill(Color.SANDY_BROWN)
	texture.set_image(image)
	collision.scale = Vector2(image_size.x / 20.0, image_size.y /20.0)

func _paint_texture(pos) -> void:
	print(pos)
	image.fill_rect(Rect2i(pos.x,pos.y,brush_size,brush_size), Color.TRANSPARENT)
	texture.update(image)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_inside.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	body_inside.remove_at(body_inside.find(body))
	
func _process(delta: float) -> void:
	for i in body_inside:
		var pos = i.global_position - global_position - offset + get_rect().size/2.0
		_paint_texture(pos)
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	body_inside.append(area)
	print("adsfasdfs")



func _on_area_2d_area_exited(area: Area2D) -> void:
	body_inside.remove_at(body_inside.find(area))
