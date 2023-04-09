shader_type canvas_item;

const float bar_size = 500.0;
uniform int direction = 1;
uniform float current_size = 500.0;

void fragment() {
	// G: 0 216 33 00d821; R: 216 0 33 d80021
	if(UV.x * bar_size >= current_size) {
		COLOR = vec4(216.0/256.0,0,33.0/256.0,1);
	} else {
		COLOR = vec4(0,216.0/256.0,33.0/256.0,1);
	}
}
