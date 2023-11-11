shader_type canvas_item;
uniform sampler2D next_texture:repeat_enable, filter_nearest;
uniform float lerp = 0.0;

void fragment() {
	vec4 next_col = texture(next_texture, UV);
	vec4 col = texture(TEXTURE, UV);
	COLOR = next_col;
}
