#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

// Custom extern from SMODS.Shader
extern PRECISION number time2;
extern PRECISION number sparkle_density;
extern PRECISION number sparkle_speed;
extern PRECISION number sparkle_size;
extern PRECISION vec4 sparkle_color;
extern PRECISION number sparkle_brightness;


vec4 dissolve_mask(vec4 final_pixel, vec2 texture_coords, vec2 uv){
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : final_pixel.xyz, shadow ? final_pixel.a*0.3: final_pixel.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (final_pixel.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            final_pixel.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            final_pixel.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : final_pixel.xyz, res > adjusted_dissolve ? (shadow ? final_pixel.a*0.3: final_pixel.a) : .0);
}

float hash(vec2 p) {
    	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
    	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.zw) / texture_details.zw;
    	vec4 pixel = vec4(0, 0, 0, 0);
    	vec2 gridPos = floor(uv * sparkle_density);
    	vec2 localUv = fract(uv * sparkle_density) - 0.5;
    
    	float seed = hash(gridPos);
    	vec2 offset = vec2(seed - 0.5, hash(gridPos + 3.7) - 0.5);
    	offset *= 0.5;
    
    	vec2 sparklePos = localUv - offset;
    	float dist = length(sparklePos);
    
    	float sparkleTime = sparkle_speed * time2 * 0.5 + seed * 15.0;
    	float life = fract(sparkleTime);
    	float sparkle = exp(-life * 15.0) * step(life, 0.3);
    
    	if (sparkle > 0.01 && dist < sparkle_size && seed > 0.4) {
		float glow = 1.0 - (dist / sparkle_size);
        	pixel = vec4(sparkle_color.r, sparkle_color.g, sparkle_color.b, sparkle_brightness * glow * sparkle);
    	}
    
    	return dissolve_mask(pixel, texture_coords, uv);
}

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position) {
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist)) *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif