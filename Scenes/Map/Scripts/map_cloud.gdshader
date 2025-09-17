shader_type canvas_item;

uniform sampler2D cloud_shadow_noise : repeat_enable;
uniform vec2 wind_direction;
uniform float wind_speed;
uniform vec2 cloud_opacity;
uniform float alpha_step;
uniform float minimum_cloud_opacity;

float scale_to_range(float value, float min_val, float max_val) {
	if (value == max_val) {
		return 1.0;
	}
	else if (value == min_val) {
		return 0.0;
	}
	return (value - min_val) / (max_val - min_val);
}

void fragment() {
	vec3 wind_shadow = texture(cloud_shadow_noise, UV + normalize(-wind_direction) * wind_speed * TIME).rgb;
	float brightness = (wind_shadow.r + wind_shadow.g + wind_shadow.b) / 3.0;
	COLOR.a = 0.0;
	if (brightness > cloud_opacity.x) {
		float normalized_brightness = scale_to_range(brightness, cloud_opacity.x, 1.0);
		float alpha = normalized_brightness * cloud_opacity.y;
		COLOR.a = alpha;
	}
}
