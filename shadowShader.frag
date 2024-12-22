//Shader
extern float pixelSize = 1;
extern float barWidth = 0;
extern float barHeight = 0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float width = screen_coords.x / texture_coords.x;
    float height = screen_coords.y / texture_coords.y;

    vec2 start = vec2(screen_coords.x - mod(screen_coords.x-barWidth,pixelSize),screen_coords.y - mod(screen_coords.y-barHeight,pixelSize));

    vec4 ave = vec4(0,0,0,0);

    if (pixelSize > 2) {
        for (int i = 0; i < pixelSize; i ++) {
            for (int j = 0; j < pixelSize; j ++) {
                ave += Texel(texture,vec2((start.x + i + .5)/width,(start.y + j + .5)/height));
            }
        }

        ave /= ceil(pixelSize) * ceil(pixelSize);
        return ave;
    }

    return Texel(texture,texture_coords);
}