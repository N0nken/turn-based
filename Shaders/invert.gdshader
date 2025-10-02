shader_type canvas_item;
uniform bool enabled = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (enabled) COLOR.rgb = vec3(1.0 - COLOR.r, 1.0 - COLOR.g, 1.0 - COLOR.b);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
