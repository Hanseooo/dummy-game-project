var horizontal_movement = 0;
var vertical_movement = 0;
var player_to_cursor_angle = point_direction(x, y, mouse_x, mouse_y)






//if (current_state != PLAYER_STATE.ATTACK && current_state !=PLAYER_STATE.ROLLING) {
    //if (is_moving) current_state = PLAYER_STATE.MOVING;
    //else current_state = PLAYER_STATE.IDLE;
//}


if (attack_timer < attack_cd) attack_timer++

if (mouse_check_button_pressed(mb_left) && attack_timer >= attack_cd && current_state != PLAYER_STATE.ROLLING) {
    current_state = PLAYER_STATE.ATTACK;
    attack_timer = 0;
    rand = irandom(2);

    // Lock the attack sprite for this swing
    if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315) {
        attack_sprite = spr_player_attack_right;
    } else if (player_to_cursor_angle < 135) {
        attack_sprite = spr_player_attack_up;
    } else if (player_to_cursor_angle < 225) {
        attack_sprite = spr_player_attack_left;
    } else {
        attack_sprite = (rand == 0) ? spr_player_attack_down2 : spr_player_attack_down;
    }
    sprite_index = attack_sprite;
    image_index = 0;
    image_speed = 1;

    audio_sound_pitch(snd_sword_swoosh, random_range(0.8, 1.2));
    audio_play_sound(snd_sword_swoosh, 0, false);

    var _inst = instance_create_depth(x, y, depth, oPlayerAttack);
    _inst.image_angle = player_to_cursor_angle;

    _inst.owner = id;
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
    
    set_invincibility_duration(30)
    
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

if (current_state != PLAYER_STATE.ATTACK && current_state != PLAYER_STATE.ROLLING) {
    current_state = is_moving ? PLAYER_STATE.MOVING : PLAYER_STATE.IDLE;
}


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
        if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315)      sprite_index = spr_player_idle_right;
        else if (player_to_cursor_angle < 135)                                  sprite_index = spr_player_idle_up;
        else if (player_to_cursor_angle < 225)                                  sprite_index = spr_player_idle_left;
        else                                                                     sprite_index = spr_player_idle_down;
        break;

    case PLAYER_STATE.MOVING:
        // Now horizontal_movement/vertical_movement are up to date
        if      (horizontal_movement > 0) sprite_index = spr_player_walk_right;
        else if (horizontal_movement < 0) sprite_index = spr_player_walk_left;
        else if (vertical_movement   > 0) sprite_index = spr_player_walk_down;
        else if (vertical_movement   < 0) sprite_index = spr_player_walk_up;
        else {
            // Safety: if MOVING but zero (edge case), fallback to idle facing
            if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315)  sprite_index = spr_player_idle_right;
            else if (player_to_cursor_angle < 135)                              sprite_index = spr_player_idle_up;
            else if (player_to_cursor_angle < 225)                              sprite_index = spr_player_idle_left;
            else                                                                 sprite_index = spr_player_idle_down;
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