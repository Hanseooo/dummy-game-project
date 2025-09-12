if (heal_effect_active && instance_exists(player_ref)) {
    var scale_x = abs(player_ref.image_xscale) * 1;
    var scale_y = abs(player_ref.image_yscale) * 1;

    // Clamp the frame index so it never goes out of range
    var frame_index = clamp(floor(heal_effect_frame), 0, sprite_get_number(spr_heal_effect) - 1);

    draw_sprite_ext(
        spr_heal_effect,
        frame_index,
        player_ref.x,
        player_ref.y,
        scale_x,
        scale_y,
        0,
        c_white,
        1
    );
}