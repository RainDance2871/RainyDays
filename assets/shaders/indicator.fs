#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;

// Custom extern from SMODS.Shader
extern MY_HIGHP_OR_MEDIUMP vec4 sphere_visible1;
extern MY_HIGHP_OR_MEDIUMP vec4 sphere_visible2;
extern MY_HIGHP_OR_MEDIUMP vec4 sphere_visible3;
extern MY_HIGHP_OR_MEDIUMP vec2 grid_origin;
extern MY_HIGHP_OR_MEDIUMP vec2 grid_dims;
extern MY_HIGHP_OR_MEDIUMP vec2 sphere_size;

float getSphereVisible(int i) {
	if (i < 0 || i >= 12) return 0.0;
    	if (i < 4) return sphere_visible1[i];
    	if (i < 8) return sphere_visible2[i - 4];
    	return sphere_visible3[i - 8];
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords) {
    	MY_HIGHP_OR_MEDIUMP vec4 tex = Texel(texture, texture_coords);
    	MY_HIGHP_OR_MEDIUMP vec2 uv = ((texture_coords * image_details) - texture_details.xy * texture_details.ba) / texture_details.ba;

	vec2 pixel = 0.5 * uv * texture_details.ba;
	vec2 tile = floor((pixel - grid_origin) / sphere_size);

	int tileIndex = int(tile.x + tile.y * grid_dims.x);
	tex.a *= getSphereVisible(tileIndex);
    	return tex;
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
   	if (hovering <= 0.0) {
        	return transform_projection * vertex_position;
    	}
    	MY_HIGHP_OR_MEDIUMP float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
    	MY_HIGHP_OR_MEDIUMP vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
    	MY_HIGHP_OR_MEDIUMP float scale = 0.2 * (-0.03 - 0.3 * max(0.0, 0.3 - mid_dist)) * hovering * (length(mouse_offset) * length(mouse_offset)) / (2.0 -mid_dist);

    	return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif