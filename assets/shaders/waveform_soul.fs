#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;

// Custom extern from SMODS.Shader
extern PRECISION number time;
extern PRECISION number scale;
extern PRECISION number speed;
extern PRECISION number height;

vec2 hash(vec2 p) {
    	return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453123);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    	vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.zw) / texture_details.zw;

    	vec2 randomValues = hash(vec2(floor(uv.x * scale), 0.0));    
    	float columnSpeed = speed * (0.5 + randomValues.y);
    	float phase = randomValues.x * 6.28 * 2.0;

    	float animation;
    	if (randomValues.y < 0.333) { 					// Smooth sine wave
       		animation = 0.5 + 0.5 * sin(columnSpeed * time + phase);
    	} else if (randomValues.y < 0.666) { 				// Faster attack, slower decay
        	float wave = sin(columnSpeed * time + phase);
        	animation = wave * wave;
    	} else { 							// Triangle wave style
        	float wave = sin(columnSpeed * time + phase);
        	animation = abs(wave);
    	}
    
    	float minHeight = max(0.0, randomValues.x * 0.1 - 0.1);
    	float maxHeight = height * (0.3 + randomValues.y * 0.2);
    
    	float border = minHeight + animation * (maxHeight - minHeight);
    	vec4 pixel = Texel(texture, texture_coords);

    	if (abs(uv.y - 0.5) > border) {
        	pixel = vec4(0, 0, 0, 0);
    	}
    	return pixel;
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