shader_type canvas_item;

uniform sampler2D normal_map;
uniform sampler2D height_map;
uniform sampler2D color_ramp;
uniform float height_multiplier = 1.0;

uniform vec3 light_direction = vec3(0.0, 1.0, 0.0);
uniform vec3 light_color = vec3(1.0, 1.0, 1.0);
uniform vec3 shadow_color = vec3(0.0, 0.0, 0.0);
uniform float light_strength = 0.5;
uniform float shadow_strength = 10;
uniform float shadow_limit = 0.5;

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

float scale_to_range(float value, float min_val, float max_val) {
	float scaled_value = 0.0;
	if (value == max_val) {
		return 1.0;
	}
	else if (value == min_val) {
		return 0.0;
	}
	return (value - min_val) / (max_val - min_val);
}

void fragment() {
	vec3 new_normal = get_normal(normal_map, UV, height_multiplier);
	NORMAL = new_normal;
	vec3 height_color = texture(height_map, UV).rgb;
	float height = (height_color.r + height_color.g + height_color.b) / 3.0;
	vec3 new_color = texture(color_ramp, vec2(height, 0.0)).rgb;
	COLOR.rgb = new_color;
	COLOR.rgb = new_color + light_color * light_strength;
	
	float angle_of_incidence = dot(normalize(light_direction), new_normal);
	if (angle_of_incidence < shadow_limit) {
		COLOR.rgb = new_color - (vec3(1.0, 1.0, 1.0) - shadow_color) / shadow_strength;
	}
	
	// uncomment to check the bitch ass normal >:(((( i hate making shaders >:(
	//COLOR.rgb = vec3(0.0, 0.0, 0.0);
	//COLOR.r = new_normal.b; 
}