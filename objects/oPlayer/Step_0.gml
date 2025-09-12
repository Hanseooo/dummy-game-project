var horizontal_movement = 0;
var vertical_movement = 0;
var player_to_cursor_angle = point_direction(x, y, mouse_x, mouse_y)



// reset combo if time’s up
if (combo_timer > 0) combo_timer--;
else combo_step = 0;

//if (current_state != PLAYER_STATE.ATTACK && current_state !=PLAYER_STATE.ROLLING) {
    //if (is_moving) current_state = PLAYER_STATE.MOVING;
    //else current_state = PLAYER_STATE.IDLE;
//}

if (combo_step > 0) attack_timer = attack_cd

if (attack_timer < attack_cd) attack_timer++
    
if (item_cooldown > 0) item_cooldown--;

// First hit requires cooldown; chained hits use combo window
if (mouse_check_button_pressed(mb_left) && current_state != PLAYER_STATE.ROLLING) {
    if (current_state != PLAYER_STATE.ATTACK) {
        if (attack_timer >= attack_cd) {
            combo_step = 1;
            start_combo_hit(combo_step);
        }
    } else {
        if (combo_timer > 0 && combo_step < 3) {
            combo_next_queued = true;
        }
    }
}

if (keyboard_check(vk_space) && current_state != PLAYER_STATE.ATTACK && roll_timer >= roll_cd && stamina >= roll_stamina_consumption && current_state != PLAYER_STATE.ROLLING) {
    stamina -= roll_stamina_consumption;
    roll_timer = 0;
    roll_traveled = 0;

    var mx = mouse_x;
    var my = mouse_y;
    var dx = mx - x;
    var dy = my - y;
    var len = point_distance(0, 0, dx, dy);
    if (len != 0) {
        roll_dir_x = dx / len;
        roll_dir_y = dy / len;
    } else {
        roll_dir_x = 1; roll_dir_y = 0;
    }
    
    audio_sound_pitch(snd_woosh, random_range(0.7, 1.1))
    audio_play_sound(snd_woosh, 0, false)
    current_state = PLAYER_STATE.ROLLING;
}

if (current_state == PLAYER_STATE.ROLLING) {
    var mvx = roll_dir_x * roll_speed;
    var mvy = roll_dir_y * roll_speed;
    
    set_invincibility_duration(game_speed*0.4)
    
    if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315) {
        roll_sprite = spr_player_roll_right;
    } else if (player_to_cursor_angle < 135) {
        roll_sprite = spr_player_roll_up;
    } else if (player_to_cursor_angle < 225) {
        roll_sprite = spr_player_roll_left;
    } else {
        roll_sprite = spr_player_roll_down;
    }
    sprite_index = roll_sprite;
    image_speed = 1.2;


    var steps  = max(1, ceil(max(abs(mvx), abs(mvy))));
    var step_x = mvx / steps;
    var step_y = mvy / steps;
    
    for (var i = 0; i < steps; i++) {
        if (!place_meeting(x + step_x, y, tilemap)) {
            x += step_x;
        } else {
            step_x = 0;
        }
        if (!place_meeting(x, y + step_y, tilemap)) {
            y += step_y;
        } else {
            step_y = 0;
        }
    }
    
    roll_traveled += point_distance(0, 0, mvx, mvy);
    
    if (roll_traveled >= roll_distance
     || (step_x == 0 && step_y == 0)) {
        current_state = PLAYER_STATE.IDLE;
    }

    exit;  
}

//dash (separate)
if (current_state == PLAYER_STATE.ATTACK && combo_step >= 2 && !did_dash_for_hit) {
    var tgt = find_dash_target(42);
    if (tgt != noone) {
        dash_toward(tgt, dash_distance, 8); // 8px buffer outside mask
    }
    did_dash_for_hit = true;
}

// Smooth dash movement
// Smooth dash movement with collision + safe stop check
if (dash_remaining > 0) {
    if (instance_exists(dash_target)) {
        var dist_to_target = point_distance(x, y, dash_target.x, dash_target.y);
        if (dist_to_target <= dash_stop_dist) {
            hspeed = 0;
            vspeed = 0;
            dash_remaining = 0;
        }
    }

    if (dash_remaining > 0) {
        var step_dist = point_distance(0, 0, hspeed, vspeed);

        // Horizontal
        if (!scr_tilemap_solid_at(x + hspeed, y, tilemap)) {
            x += hspeed;
        } else {
            hspeed = 0;
        }

        // Vertical
        if (!scr_tilemap_solid_at(x, y + vspeed, tilemap)) {
            y += vspeed;
        } else {
            vspeed = 0;
        }

        dash_remaining -= step_dist;

        if (dash_remaining <= 0) {
            hspeed = 0;
            vspeed = 0;
        }
    }
}


if (keyboard_check(ord("D"))) horizontal_movement++; 
if (keyboard_check(ord("A"))) horizontal_movement--; 
if (keyboard_check(ord("W"))) vertical_movement--; 
if (keyboard_check(ord("S"))) vertical_movement++; 

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
is_moving = (horizontal_movement != 0 || vertical_movement != 0);

if (current_state != PLAYER_STATE.ATTACK && current_state != PLAYER_STATE.ROLLING) {
    if (is_moving) current_state = PLAYER_STATE.MOVING;
    else current_state = PLAYER_STATE.IDLE;
}

// ——— SEGMENT END ———
if (current_state == PLAYER_STATE.ATTACK) {
    if (floor(image_index) >= attack_end_frame) {
        if (combo_next_queued && combo_step < 3) {
            combo_step++;
            combo_next_queued = false;
            start_combo_hit(combo_step);
        } else {
            var moving = (horizontal_movement != 0 || vertical_movement != 0);
            current_state = moving ? PLAYER_STATE.MOVING : PLAYER_STATE.IDLE;
        }
    }
}

if (keyboard_check(ord("Z"))) {
    useItem()
}



if (hp < max_hp && hp_timer >= hp_delay) {
    temp_hp += hp_regen
    if (temp_hp == 1) {
        temp_hp = 0
        hp++
    }
}
if (hp_timer <= hp_delay) hp_timer++
    
if (roll_timer <= roll_cd) roll_timer++
    
if (stamina <= max_stamina) {
    stamina += stamina_regen
}




if (knockback_force > 0) {
    var knockback_decay = 0.5
    hspeed += lengthdir_x(knockback_force, knockback_dir);
    vspeed += lengthdir_y(knockback_force, knockback_dir);
    knockback_force -= knockback_decay;
    if (knockback_force < 0) knockback_force = 0;
}


hspeed *= 0.85;
vspeed *= 0.85;

// Clamp vesocity
var max_speed = 2;
hspeed = clamp(hspeed, -max_speed, max_speed);
vspeed = clamp(vspeed, -max_speed, max_speed);

// Apply movement with collision
if (!scr_tilemap_solid_at(x + hspeed, y, tilemap)) {
    x += hspeed;
} else {
    hspeed = 0;
}

if (!scr_tilemap_solid_at(x, y + vspeed, tilemap)) {
    y += vspeed;
} else {
    vspeed = 0;
}

if (pulse_timer > 0) {
    pulse_timer--;

    if (pulse_timer mod pulse_interval == 0) {
        pulse_alpha_state = (pulse_alpha_state == 1) ? 0.5 : 1;
    }

    image_alpha = pulse_alpha_state;
} else {
    image_alpha = 1; 
}

is_moving = (horizontal_movement != 0 || vertical_movement != 0);

//if (current_state != PLAYER_STATE.ATTACK && current_state != PLAYER_STATE.ROLLING) {
    //current_state = is_moving ? PLAYER_STATE.MOVING : PLAYER_STATE.IDLE;
//}


//if (!is_moving) {
//    switch (sprite_index) {
//        case spr_player_walk_right: sprite_index = spr_player_idle_right; break;
//        case spr_player_walk_left:  sprite_index = spr_player_idle_left; break;
//        case spr_player_walk_up:    sprite_index = spr_player_idle_up; break;
//        case spr_player_walk_down:  sprite_index = spr_player_idle_down; break;
//    }
//}



switch (current_state) {
    case PLAYER_STATE.IDLE:
        if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315) {
            sprite_index = spr_player_idle_right;
            image_xscale = 1;
        }
        else if (player_to_cursor_angle < 135) {
            sprite_index = spr_player_idle_up;
            image_xscale = 1;
        }
        else if (player_to_cursor_angle < 225) {
            sprite_index = spr_player_idle_right; // use right sprite
            image_xscale = -1; // flip for left
        }
        else {
            sprite_index = spr_player_idle_down;
            image_xscale = 1;
        }
        break;
    
    case PLAYER_STATE.MOVING:
        if (horizontal_movement > 0) {
            sprite_index = spr_player_walk_right;
            image_xscale = 1;
        }
        else if (horizontal_movement < 0) {
            sprite_index = spr_player_walk_right; // use right sprite
            image_xscale = -1; // flip for left
        }
        else if (vertical_movement > 0) {
            sprite_index = spr_player_walk_down;
            image_xscale = 1;
        }
        else if (vertical_movement < 0) {
            sprite_index = spr_player_walk_up;
            image_xscale = 1;
        }
        break;

    case PLAYER_STATE.ATTACK:
        if (sprite_index != attack_sprite) {
            sprite_index = attack_sprite; // don't reset image_index here
        }
        break;

    case PLAYER_STATE.ROLLING:
        if (sprite_index != roll_sprite) sprite_index = roll_sprite;
        image_speed = 1;
        break;
    

}
//
//if (current_state == PLAYER_STATE.ATTACK) {
    //// Once we at least hit the last frame, go back to move/idle
    //if (image_index > attack_end_frame + 1) {
        //var moving = (horizontal_movement != 0 || vertical_movement != 0);
        //current_state = moving ? PLAYER_STATE.MOVING : PLAYER_STATE.IDLE;
    //}
//}