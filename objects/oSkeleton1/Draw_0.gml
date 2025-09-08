if (hit_flash_timer >= 0) {
    shader_set(sh_whitefill);
    draw_sprite_ext(
        sprite_index,
        image_index,
        x, y,
        image_xscale,    // keep same X scale
        image_yscale,    // keep same Y scale
        image_angle,     // keep rotation
        c_white,
        image_alpha      // keep transparency if needed
    );
    shader_reset();
} else {
    draw_self();
}