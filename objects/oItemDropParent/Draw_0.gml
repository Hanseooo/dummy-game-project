// Hover offset
var y_offset = sin(hover_timer) * hover_height;

// Slow rotation
var rot = sin(hover_timer * 0.25) * 2; // sway between -5° and +5°
// Or: var rot = hover_timer; // continuous spin

// Scale
var scale = 0.5;

// Draw with hover, rotation, and scale
draw_sprite_ext(sprite_index, image_index, x, y + y_offset, scale, scale, rot, image_blend, image_alpha);