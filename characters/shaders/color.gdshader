shader_type canvas_item;



uniform vec4 new_color: source_color;
uniform vec4 threahold: source_color;

uniform vec4 colors[2]: source_color;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	if (current_color.r < threahold.r) {
		if (current_color.g < threahold.g) {
			if (current_color.b < threahold.b) {
				discard;
			}
		}
	}

	float temp_diff;
	float diff = 1000000.0;
	vec3 hsv_current_color = rgb2hsv(current_color.rgb);
	vec3 hsv_new_color;
	vec3 hsv_result_color;
	for (int i = 0; i < colors.length(); i++) {
		hsv_new_color = rgb2hsv(colors[i].rgb);
		temp_diff = distance(hsv_current_color, hsv_new_color);
		if (temp_diff < diff) {
			diff = temp_diff;
			hsv_result_color = vec3(hsv_new_color.r, hsv_new_color.g, hsv_current_color.b);
			COLOR.rgb = hsv2rgb(hsv_result_color);
		}
	}

}
