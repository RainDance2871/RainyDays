#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec2 metallic_highlight;

extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

// Custom extern from SMODS.Shader
extern PRECISION number brightness;
extern PRECISION number scaling;

vec4 dissolve_mask(vec4 final_pixel, vec2 texture_coords, vec2 uv);

// GLSL Simplex noise function
vec3 permute(vec3 x) {
	return mod(((x * 34.) + 1.) * x, 289.0);
}

float snoise(vec2 v) {
  	const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  	vec2 i = floor(v + dot(v, C.yy));
  	vec2 x0 = v - i + dot(i, C.xx);
  	vec2 i1 = (x0.x > x0.y) ? vec2(1., 0.) : vec2(0., 1.);
  	vec4 x12 = x0.xyxy + C.xxzz;
  	x12.xy = x12.xy - i1;
  	i = mod(i, 289.);
  	vec3 p = permute(permute(i.y + vec3(0., i1.y, 1.)) + i.x + vec3(0., i1.x, 1.));
  	vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.);
  	m = m * m;
  	m = m * m;
  	vec3 x = 2. * fract(p * C.www) - 1.;
  	vec3 h = abs(x) - 0.5;
  	vec3 ox = floor(x + 0.5);
  	vec3 a0 = x - ox;
  	m = m * (1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h));
  	vec3 g;
  	g.x = a0.x * x0.x + h.x * x0.y;
  	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  	return 130. * dot(m, g);
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.zw) / texture_details.zw;
    	vec4 pixel = Texel(texture, texture_coords);

	number maximum = max(pixel.r, max(pixel.g, pixel.b));
	number t = 0.025 * metallic_highlight.x;
	vec2 texco_offset = scaling * texture_coords;

    	number fac = 0.3 + sin((texco_offset.x * 450. + sin(t * 6.) * 180.) - 700. * t - sin((texco_offset.x * 190. + texco_offset.y * 30.) + 1080.3 * t));
	float noise = snoise(20. * vec2(uv.x, 2. * uv.x + 3. * uv.y) + metallic_highlight.x);

    	pixel.r = max(pixel.r, brightness * noise * (1. - pixel.r) * maximum * fac + pixel.r);
    	pixel.g = max(pixel.g, brightness * noise * (1. - pixel.g) * maximum * fac + pixel.g);
    	pixel.b = max(pixel.b, brightness * noise * (1. - pixel.b) * maximum * fac + pixel.b);
	return dissolve_mask(pixel, texture_coords, uv);
}

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