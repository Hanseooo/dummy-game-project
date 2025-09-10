if (keyboard_check_pressed(vk_escape)) {
    paused = !paused;
    
    if (paused) {
        // Create a surface of the room size
        if (!surface_exists(paused_surf)) {
            paused_surf = surface_create(room_width, room_height);
        }
        // Draw the current screen into the surface
        surface_set_target(paused_surf);
        draw_clear_alpha(c_black, 0);
        draw_self();                   // or draw the full room
        surface_reset_target();
        
        // Deactivate everything except this controller
        instance_deactivate_all(true);
        instance_activate_object(object_index);
        instance_activate_object(oCursor);
        
    } else {
        // Reactivate all instances
        instance_activate_all();
        // Free the surface
        if (surface_exists(paused_surf)) {
            surface_free(paused_surf);
            paused_surf = -1;
        }
    }
}