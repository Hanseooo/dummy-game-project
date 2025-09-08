// — Draw GUI Event —

/// bar dimensions (set these once in Create)
var gui_x       = 32;
var gui_y       = 32;
var bar_width   = 100;
var bar_height  = 22;
var bar_spacing = 8;        // gap between health and stamina bars

// 1) Health Bar  
// background
draw_set_color(make_color_rgb(40, 40, 40));
draw_roundrect(gui_x, gui_y,
               gui_x + bar_width, gui_y + bar_height,
               false);

// fill
var hp_ratio   = hp / max_hp;
var hp_width   = bar_width * hp_ratio;
draw_set_color(c_red);
draw_roundrect(gui_x,        gui_y,
               gui_x + hp_width, gui_y + bar_height,
               false);

// outline
draw_set_color(c_white);
draw_roundrect(gui_x - 1,          gui_y - 1,
               gui_x + bar_width + 1, gui_y + bar_height + 1,
               true);

// text
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(gui_x + bar_width/2, gui_y + bar_height/2,
          string(hp) + " / " + string(max_hp));


// 2) Stamina Bar  
var st_y = gui_y + bar_height + bar_spacing;

// background
draw_set_color(make_color_rgb(40, 40, 40));
draw_roundrect(gui_x,     st_y,
               gui_x + bar_width, st_y + bar_height,
               false);

// fill
var st_ratio = stamina / max_stamina;
var st_width = bar_width * st_ratio;
draw_set_color(make_color_rgb(100, 180, 255)); // bluish
draw_roundrect(gui_x,         st_y,
               gui_x + st_width, st_y + bar_height,
               false);

// outline
draw_set_color(c_white);
draw_roundrect(gui_x - 1,             st_y - 1,
               gui_x + bar_width + 1, st_y + bar_height + 1,
               true);

// text
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(gui_x + bar_width/2, st_y + bar_height/2,
          string(floor(stamina)) + " / " + string(max_stamina));