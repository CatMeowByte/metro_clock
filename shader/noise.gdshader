shader_type canvas_item;
render_mode unshaded;

// Pseudo-random number generator
float random(vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	float noise = random(UV * TIME);
	COLOR = vec4(noise, noise, noise, 1.0);
}