#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

// Custom extern from SMODS.Shader
extern PRECISION number brightness;
extern PRECISION number tilt;
extern PRECISION number scaling;

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
	vec2 texco_offset = scaling * texture_coords;
	
    	number fac = 0.3 + sin((texco_offset.x * 450.0 + sin(tilt * 6.0) * 180.0) - 700.0 * tilt - sin((texco_offset.x * 190.0 + texco_offset.y * 30.0) + 1080.3 * tilt));
	float noise = snoise(20. * vec2(uv.x, 2. * uv.x + 3. * uv.y));

    	pixel.r = max(pixel.r, brightness * noise * (1. - pixel.r) * maximum * fac + pixel.r);
    	pixel.g = max(pixel.g, brightness * noise * (1. - pixel.g) * maximum * fac + pixel.g);
    	pixel.b = max(pixel.b, brightness * noise * (1. - pixel.b) * maximum * fac + pixel.b);
	return pixel;
}

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position) {
    if (hovering <= 0.0) {
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist)) *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif