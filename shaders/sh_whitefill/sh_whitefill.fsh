varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    if (tex.a < 0.5) discard; // ignore semi-transparent pixels
    gl_FragColor = vec4(0.9, 0.9, 0.9, tex.a) * v_vColour.a;
}