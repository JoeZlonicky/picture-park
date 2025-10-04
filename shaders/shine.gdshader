shader_type canvas_item;

uniform sampler2D alpha_gradient;
uniform sampler2D color_gradient;

uniform float size_effect: hint_range(-5.0, 5.0, 0.05) = 0.1;
uniform float speed = 1;
uniform float highlight_strength: hint_range(-4.0, 4.0, 0.05) = 0.5;
uniform bool is_horizontal = false;

varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	// Set up base parameters
	vec4 old_color = texture(TEXTURE, UV) * modulate;
	float time = TIME * speed;
	float current_time = fract(-time);

	// Set time to fit better with the effect
	current_time = mix(0. - size_effect, 1. + size_effect, current_time);

	float effect_lower_bound = current_time - size_effect;
	float effect_upper_bound = current_time + size_effect;
	float position_value = (is_horizontal) ? UV.x : UV.y;

	// Smooth out the lower/upper bounds with the UV values to calculate how far from the middle point(the effect) the pixel is
	float effect_distance = smoothstep(effect_lower_bound, current_time, position_value) - smoothstep(current_time, effect_upper_bound, position_value);

	// Get the position of the pixel within the effect for the inner_gradient color mode
	float inner_effect_position = smoothstep(effect_lower_bound, effect_upper_bound, position_value);

	// Get the new color from the gradient
	vec2 color_position = vec2(current_time);
	vec4 new_color = vec4(texture(color_gradient, color_position));

	// Mix using alpha gradient
	new_color = mix(old_color, new_color, vec4(texture(alpha_gradient, vec2(current_time))));

	COLOR.rgb = mix(old_color.rgb, new_color.rgb, vec3(effect_distance * highlight_strength));
}