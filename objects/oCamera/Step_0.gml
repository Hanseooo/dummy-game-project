if (instance_exists(target)) {
    // Desired position centered on target
    var desired_x = target.x - (camera_get_view_width(cam) / 2);
    var desired_y = target.y - (camera_get_view_height(cam) / 2);

    // Smooth follow
    cam_x = lerp(cam_x, desired_x, follow_speed);
    cam_y = lerp(cam_y, desired_y, follow_speed);

    // Smooth zoom
    zoom_current = lerp(zoom_current, zoom_target, zoom_speed);

    // Apply zoom to camera size
    var cam_w = base_width / zoom_current;
    var cam_h = base_height / zoom_current;
    camera_set_view_size(cam, cam_w, cam_h);

    // Apply shake
    if (shake_time > 0) {
        shake_time--;
        cam_x += random_range(-shake_strength, shake_strength);
        cam_y += random_range(-shake_strength, shake_strength);
    }

    // Clamp to room bounds
    cam_x = clamp(cam_x, 0, room_width  - cam_w);
    cam_y = clamp(cam_y, 0, room_height - cam_h);

    // Apply position
    camera_set_view_pos(cam, cam_x, cam_y);
}

if (zoom_target > 1 && shake_time <= 0) {
    zoom_target = 1; // return to normal
}


