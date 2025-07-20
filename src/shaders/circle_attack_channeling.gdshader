shader_type canvas_item;

uniform float border_width : hint_range(0.0, 0.5) = 0.05;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 fill_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = FRAGCOORD.xy / TEXTURE_PIXEL_SIZE;
    vec2 center = TEXTURE_PIXEL_SIZE * 0.5;
    
    float dist = distance(UV, center);
    float radius = min(TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y) * 0.5 - border_width;
    
    float border = (smoothstep(radius - border_width, radius, dist) - 
                  smoothstep(radius, radius + border_width, dist));
    
    float filled = 1.0 - smoothstep(radius * progress - border_width, 
                                  radius * progress + border_width, dist);
	
    vec4 final_color = vec4(0.0);
    
    if (filled > 0.0) {
        final_color = mix(final_color, fill_color, filled);
    }
    
    if (border > 0.0) {
        final_color = mix(final_color, border_color, border);
    }
    
    COLOR = final_color;
}
