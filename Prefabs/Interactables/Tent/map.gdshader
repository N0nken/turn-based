shader_type canvas_item;

uniform sampler2D height_map;
uniform sampler2D detail_height_map;
uniform sampler2D gradient;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 height_color = texture(height_map, UV);
	float height = (height_color.r + height_color.g + height_color.b) / 3.0;
	COLOR = height_color;
	//COLOR.rgb = texture(color_curve, vec2(height, UV.y)).rgb;
	//vec4 detail_height_color = texture(detail_height_map, UV);
	//float brightness_factor = height / COLOR.b;
	//if (COLOR.r >= COLOR.g && COLOR.r >= COLOR.b) {
		//brightness_factor = height / COLOR.r;
	//} else if (COLOR.g >= COLOR.r && COLOR.g >= COLOR.b) {
		//brightness_factor = height / COLOR.g;
	//}
	//COLOR.rgb *= brightness_factor;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
