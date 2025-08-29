var horizontal_movement = 0;
var vertical_movement = 0;

if (keyboard_check(ord("D"))) { horizontal_movement++; sprite_index = spr_player_walk_right; }
if (keyboard_check(ord("A"))) { horizontal_movement--; sprite_index = spr_player_walk_left; }
if (keyboard_check(ord("W"))) { vertical_movement--; sprite_index = spr_player_walk_up; }
if (keyboard_check(ord("S"))) { vertical_movement++; sprite_index = spr_player_walk_down; }

// ==== SAFE MOVEMENT LOOP ====
var dx = horizontal_movement * move_speed;
var dy = vertical_movement * move_speed;

// Slice into collision-safe steps
var steps = max(1, ceil(max(abs(dx), abs(dy))));
var step_x = dx / steps;
var step_y = dy / steps;

for (var i = 0; i < steps; i++) {
    // Horizontal move check
    if (!place_meeting(x + step_x, y, tilemap)) {
        x += step_x;
    } else {
        step_x = 0; // block horizontal movement
    }

    // Vertical move check
    if (!place_meeting(x, y + step_y, tilemap)) {
        y += step_y;
    } else {
        step_y = 0; // block vertical movement
    }
}
var isMoving = (horizontal_movement != 0 || vertical_movement != 0);

if (!isMoving) {
    switch (sprite_index) {
        case spr_player_walk_right: sprite_index = spr_player_idle_right; break;
        case spr_player_walk_left:  sprite_index = spr_player_idle_left; break;
        case spr_player_walk_up:    sprite_index = spr_player_idle_up; break;
        case spr_player_walk_down:  sprite_index = spr_player_idle_down; break;
    }
}

if (mouse_check_button_pressed(mb_left) && attack_timer >= attack_cd) {
    
}

if (attack_timer < attack_cd) attack_timer++