// myshader.gdshader

shader_type canvas_item;

#include "my_aa.gdshaderinc"

void fragment() {
	//vec2 p = my_aa(UV, TEXTURE_PIXEL_SIZE, fwidth(UV));
	vec2 p;
	float a = COLOR.a;
	MY_AA(p, UV, TEXTURE_PIXEL_SIZE);
	
	COLOR = texture(TEXTURE, p);
	COLOR.a = a;
}