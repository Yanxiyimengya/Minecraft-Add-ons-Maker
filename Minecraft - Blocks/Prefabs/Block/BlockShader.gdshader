shader_type canvas_item;
uniform sampler2D next_texture;
uniform float lerp = 0.0;

void fragment() {
	vec4 sc = texture(TEXTURE, UV);
	vec4 nc = texture(next_texture, UV);
	COLOR = nc;
}
