shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform bool reverse = false;

void fragment() {
	if ((UV.x + UV.y) > (2.0 * progress)) {
		if (reverse) {
			discard;
		}
	}
	else if (!reverse) {
		discard;
	}
}
