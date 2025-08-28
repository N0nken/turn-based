shader_type canvas_item;

uniform sampler2D height_map;
uniform sampler2D gradient;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(height_map, UV);
}
