shader_type canvas_item;

uniform bool enabled;
uniform vec4 outline_color;
uniform bool inner;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (enabled) {
		vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
		if (inner) {
			if (COLOR.a == 1.0) {
				for (int y = -1; y < 2; y++) {
					for (int x = -1; x < 2; x++) {
						vec2 pixel_off = vec2(float(x),float(y));
						vec4 tex = texture(TEXTURE, UV + pixel_off * pixel_size);
						if (tex.a == 0.0) {
							COLOR.rgba = outline_color;
						}
					}
				}
			}
		} else {
			if (COLOR.a == 0.0) {
				for (int y = -1; y < 2; y++) {
					for (int x = -1; x < 2; x++) {
						vec2 pixel_off = vec2(float(x),float(y));
						vec4 tex = texture(TEXTURE, UV + pixel_off * pixel_size);
						if (tex.a == 1.0) {
							COLOR.rgba = outline_color;
						}
					}
				}
			}
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
