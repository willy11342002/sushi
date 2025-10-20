shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform bool reverse = false;

void fragment() {
	if (!reverse) {
		COLOR.a = 1.0 - progress;
	}
	else {
		COLOR.a = progress;
	}
}
