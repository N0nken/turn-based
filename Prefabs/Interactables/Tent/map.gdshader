shader_type canvas_item;

uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 noise_color = texture(noise, UV);
	float avg_color = (noise_color.r + noise_color.g + noise_color.b) / 3.0;
	if (avg_color < 0.3) {
		COLOR.rgb = vec3(0.0, 0.0, 1.0);
	} else if (avg_color < 0.6) {
		COLOR.rgb = vec3(0.0, 1.0, 0.0);
	} else if (avg_color < 0.9) {
		COLOR.rgb = vec3(0.1, 0.1, 0.1);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
