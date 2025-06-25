shader_type canvas_item;

float rand(vec2 uv) {
	 return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    float time = TIME * 0.00000001;
    float star_value = rand(UV + vec2(time));
    if (star_value >0.998){
        float brightness = 0.8 + 0.2 * sin(TIME * 2.0 + UV.x * 1.0);
       } else {
        COLOR = vec4(0.0);
    }
}