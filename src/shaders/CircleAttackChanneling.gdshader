shader_type canvas_item;

uniform float border_width : hint_range(0.0, 0.5) = 0.01;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float angle : hint_range(0.0, 1.0) = 1.0;
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 0.7);
uniform vec4 fill_color : source_color = vec4(1.0, 0.0, 0.0, 0.7);

void fragment() {
    vec2 uv = FRAGCOORD.xy / TEXTURE_PIXEL_SIZE;
    vec2 center = TEXTURE_PIXEL_SIZE * 0.5;

    float dist = distance(UV, center);
    float radius = min(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y) * 0.5 - border_width;

    float border = (smoothstep(radius - border_width, radius, dist) -
                  smoothstep(radius, radius + border_width, dist));

    float filled = 1.0 - smoothstep(radius * progress - border_width,
                                  radius * progress + border_width, dist);

    vec2 dir = UV - center;
    float frag_angle = atan(dir.y, dir.x);
    float normalized_angle = mod(frag_angle + PI, PI * 2.0) - PI;
    bool angle_visible = abs(normalized_angle) <= (PI * angle);

    vec4 final_color = vec4(0.0);

    if (filled > 0.0 && angle_visible) {
        final_color = mix(final_color, fill_color, filled);
    }

    // Draw edge borders only inside circle
    float angle_min = -1.0 * PI * angle;
    float angle_max = 1.0 * PI * angle;
    float edge_border = 0.0;


	if (angle < 1.0) {

    	float left_edge = smoothstep(angle_min - border_width, angle_min, frag_angle) -
                     smoothstep(angle_min, angle_min + border_width, frag_angle);

    	float right_edge = smoothstep(angle_max - border_width, angle_max, frag_angle) -
                      smoothstep(angle_max, angle_max + border_width, frag_angle);
		edge_border = max(left_edge, right_edge);
	}

    // Only show edge border inside circle and within angle
    float circle_visible = smoothstep(dist, dist + border_width, radius);
    edge_border *= circle_visible;

    if ((border > 0.0 && angle_visible) || (edge_border > 0.0)) {
        final_color = mix(final_color, border_color, max(border, edge_border));
    }

    COLOR = final_color;
}
