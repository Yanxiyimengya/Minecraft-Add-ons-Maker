shader_type canvas_item;
uniform sampler2D next_texture;
uniform float lerp = 0.0;

void fragment() {
	COLOR = mix(texture(TEXTURE, UV), texture(next_texture, UV), lerp);
}
