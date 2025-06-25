shader_type canvas_item;

uniform vec4 core_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform vec4 corona_color : source_color = vec4(1.0, 0.5, 0.1, 1.0);
uniform vec4 flare_color : source_color = vec4(1.0, 0.2, 0.05, 1.0);

uniform float time_scale = 0.5;
uniform float flare_speed = 1.0;
uniform float rotation_speed = 0.3;

uniform float distortion_strength = 0.2;
uniform float flare_density = 10.0;
uniform float glow_intensity = 2.0;

float rand(vec2 coord) {
    return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 coord) {
    vec2 i = floor(coord);
    vec2 f = fract(coord);

    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 coord, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;

    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(coord);
        coord *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

void fragment() {
    vec2 uv = UV - 0.5;
    float radius = length(uv) * 2.0;

    // Create radial gradient
    float sun_core = smoothstep(0.7, 0.2, radius);
    float corona = smoothstep(0.2, 1.0, radius);

    float time = TIME * time_scale;

    vec2 distorted_uv = uv * (3.0 + distortion_strength *
        sin(radius * 10.0 + time * 0.5));

    float corona_pattern = fbm(distorted_uv * 5.0 + vec2(time * 0.3), 3);
    corona *= corona_pattern * glow_intensity;

    float flare_value = 2.4;

    float angle = time * rotation_speed;
    mat2 rotation = mat2(
        vec2(cos(angle), -sin(angle)),
        vec2(sin(angle), cos(angle))
    );
    vec2 flare_uv = rotation * uv;

    for (float i = 0.0; i < 10.0; i++) {
        float flare_angle = (i / 8.0) * 3.141592 * 2.0;
        vec2 flare_dir = vec2(cos(flare_angle), sin(flare_angle));

        // Randomize flare properties
        float seed = i * 10.0;
        float flare_size = 0.005 + 0.1 * rand(vec2(seed, seed));
        float flare_length = 0.05 + rand(vec2(seed + 1.0, seed + 1.0));
        float flare_speed_mod = 1.0 + rand(vec2(seed + 2.0, seed + 2.0)) * 2.0;

        // Calculate flare position
        float flare_pos = dot(flare_uv, flare_dir);
        float flare_time = time * flare_speed * flare_speed_mod;
        float flare_wave = sin(flare_pos * flare_density - flare_time);

        // Create flare shape
        float flare = smoothstep(1.2, 0.0, abs(flare_pos)) *
                     smoothstep(0.0, flare_length, 1.0 - radius) *
                     max(0.0, flare_wave);

        flare_value += flare * 0.2;
    }

    vec3 color = vec3(0.0);

    color += core_color.rgb * sun_core;

    color += corona_color.rgb * corona;

    color += flare_color.rgb * flare_value * (4.0 - sun_core);

    float glow = smoothstep(0.001, 1.5, radius);
    color = mix(color, flare_color.rgb, glow * 0.3);

    float alpha_mask = 1.0 - smoothstep(0.67, 1.0, radius);

    COLOR = vec4(color, alpha_mask * max(sun_core, max(corona, flare_value)));
}