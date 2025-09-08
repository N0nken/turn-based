shader_type canvas_item;

uniform sampler2D color_map;
uniform sampler2D normal_map;
uniform sampler2D coconut;
uniform float coconut_scale = 0.1;


void vertex() {
	//166922	409c30
}

void fragment() {
	//NORMAL.rgb = 2.0 * texture(normal_map, UV).rgb - 1.0;
	COLOR.rgb = (texture(color_map, UV).rgb);// - texture(coconut, UV).rgb * coconut_scale);
}