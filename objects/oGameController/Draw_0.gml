if (paused && surface_exists(paused_surf)) {
    // Draw the frozen background
    draw_surface(paused_surf, 0, 0);
    
    // Darken and tint
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    
    // Draw “Paused” text centered
    var mx = display_get_gui_width()  / 2;
    var my = display_get_gui_height() / 2;
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    //draw_set_font(fnt_title);
    //draw_text(mx, my, "PAUSED");
}