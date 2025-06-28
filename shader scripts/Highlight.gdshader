shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0, 10) = 2.0;

void fragment() {
	vec2 uv = UV;
	vec4 tex = texture(TEXTURE, uv);

	if (tex.a < 0.5) {
		float max_alpha = 0.0;
		for (float x = -outline_width; x <= outline_width; x += 1.0) {
			for (float y = -outline_width; y <= outline_width; y += 1.0) {
				vec2 offset = vec2(x, y) / vec2(textureSize(TEXTURE, 0));
				max_alpha = max(max_alpha, texture(TEXTURE, uv + offset).a);
			}
		}
		if (max_alpha > 0.5) {
			COLOR = outline_color;
			discard;
        }
    }

    COLOR = tex;
}