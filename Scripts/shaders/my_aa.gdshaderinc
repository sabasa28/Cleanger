// my_aa.gdshaderinc

#define MY_AA(new_uv, uv, texture_pixel_size) new_uv = floor(uv / texture_pixel_size + 0.5) * texture_pixel_size + clamp((mod(uv + texture_pixel_size * 0.5, texture_pixel_size) - texture_pixel_size * 0.5) / fwidth(uv), -0.5, 0.5) * texture_pixel_size

//no se llama 
//vec2 myaa(vec2 uv, vec2 texture_pixel_size, vec2 fwidth_uv) {
	//vec2 closest_corner = uv;
	//closest_corner /= texture_pixel_size;
	//// round is buggy
	////closest_corner = round(closest_corner);
	//closest_corner = floor(closest_corner + 0.5);
	//closest_corner *= texture_pixel_size;
//
	//vec2 d = uv;
	//d += texture_pixel_size * 0.5;
	//d = mod(d, texture_pixel_size);
	//d -= texture_pixel_size * 0.5;
	//d /= fwidth_uv;
//
	//return closest_corner + clamp(d, -0.5, 0.5) * texture_pixel_size;
//}