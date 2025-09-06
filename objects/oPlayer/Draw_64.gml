// Position on screen (top-left corner)
var gui_x = 32;
var gui_y = 32;

// Background bar (gray)
draw_set_color(make_color_rgb(40, 40, 40));
draw_roundrect(gui_x, gui_y, gui_x + bar_width, gui_y + bar_height, false);

// Health fill (gradient red)
var hp_ratio = hp / max_hp;
var fill_width = bar_width * hp_ratio;

draw_set_color(c_red);
draw_roundrect(gui_x, gui_y, gui_x + fill_width, gui_y + bar_height, false);

// Border (white outline)
draw_set_color(c_white);
draw_roundrect(gui_x - 1, gui_y - 1, gui_x + bar_width + 1, gui_y + bar_height + 1, true);

// Optional: Text label
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(gui_x + bar_width / 2, gui_y + bar_height / 2, string(hp) + " / " + string(max_hp));