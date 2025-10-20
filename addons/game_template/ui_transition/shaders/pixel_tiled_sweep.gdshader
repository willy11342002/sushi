shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform bool reverse = false;
uniform vec2 number_of_tiles = vec2(16, 9);
uniform vec2 pixel_per_tile = vec2(16, 16);


void fragment() {
	vec2 position_in_square = UV * number_of_tiles;
	vec2 pixel_position = round(position_in_square * pixel_per_tile);
	vec2 frac = fract(pixel_position / pixel_per_tile);
	vec2 direction = abs(frac - 0.5);
	
	if ((direction.x + direction.y + UV.x + UV.y) > (4.0 * progress)) {
		if (reverse) {
			discard;
		}
	}
	else if (!reverse) {
		discard;
	}
}
