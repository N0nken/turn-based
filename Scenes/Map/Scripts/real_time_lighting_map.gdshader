shader_type canvas_item;

uniform sampler2D normal_map;
uniform sampler2D color_map;
uniform float height_multiplier = 1.0;
uniform bool show_normals = false;

vec3 get_normal(sampler2D text, vec2 coords, float height_multi) {
	vec3 normal = vec3(0.0, 0.0, 0.0);
	vec2 pixel_size = 1.0 / vec2(textureSize(text, 0));

	// get x angle
	vec3 x_surface = vec3(2.0, 0.0, 0.0);
	vec3 x_neg_neighbor_color = texture(text, coords - vec2(1.0, 0.0) * pixel_size).rgb;
	vec3 x_pos_neighbor_color = texture(text, coords + vec2(1.0, 0.0) * pixel_size).rgb;
	float x_nn_height = (x_neg_neighbor_color.r + x_neg_neighbor_color.g + x_neg_neighbor_color.b) / 3.0;
	float x_np_height = (x_pos_neighbor_color.r + x_pos_neighbor_color.g + x_pos_neighbor_color.b) / 3.0;
	x_surface.z = x_np_height - x_nn_height;
	x_surface.z *= height_multi;

	// get y angle
	vec3 y_surface = vec3(0.0, 2.0, 0.0);
	vec3 y_neg_neighbor_color = texture(text, coords - vec2(0.0, 1.0) * pixel_size).rgb;
	vec3 y_pos_neighbor_color = texture(text, coords + vec2(0.0, 1.0) * pixel_size).rgb;
	float y_nn_height = (y_neg_neighbor_color.r + y_neg_neighbor_color.g + y_neg_neighbor_color.b) / 3.0;
	float y_np_height = (y_pos_neighbor_color.r + y_pos_neighbor_color.g + y_pos_neighbor_color.b) / 3.0;
	y_surface.z = y_np_height - y_nn_height;
	y_surface.z *= height_multi;

	normal = cross(x_surface, y_surface);
	normal = normalize(normal);
	return normal;
}

void fragment() {
	vec3 height_color = texture(normal_map, UV).rgb;
	float height = (height_color.r + height_color.g + height_color.b)/3.0;
	vec3 new_normal = get_normal(normal_map, UV, height_multiplier);
	NORMAL = new_normal;
	COLOR.rgb = texture(color_map, UV).rgb;

	// uncomment to check the bitch ass normal >:(((( i hate making shaders >:(
	if (show_normals) {
		COLOR.rgb = vec3(0.0, 0.0, 0.0);
		COLOR.rgb = new_normal.rgb;
	}

}