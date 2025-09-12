if (heal_effect_active) {
    // Advance by the sprite's own speed
    heal_effect_frame += 0.1;

    var total_frames = sprite_get_number(spr_heal_effect)-2;

    // Turn off 1 frame after the last frame
    if (heal_effect_frame > total_frames) {
        heal_effect_active = false;
    }
}