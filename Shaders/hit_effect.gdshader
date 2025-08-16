shader_type canvas_item;

uniform bool enabled;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (enabled) {
		if (COLOR.a > 0.0){
			COLOR = vec4(1.0,1.0,1.0,1.0);
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
