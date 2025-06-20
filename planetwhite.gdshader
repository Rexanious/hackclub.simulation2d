shader_type canvas_item;
uniform vec4 color : source_color = vec4(0.8, 0.6, 1.0, 1.0);

void fragment() {
    float glow = 1.0 - distance(UV, vec2(0.5)) * 2.0;
    COLOR = color * (glow * 1.5);
}