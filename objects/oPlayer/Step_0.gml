var horizontal_movement = 0;
var vertical_movement = 0;
var player_to_cursor_angle = point_direction(x, y, mouse_x, mouse_y)


if (attack_timer < attack_cd) attack_timer++

if (mouse_check_button_pressed(mb_left) && attack_timer >= attack_cd) {
    current_state = PLAYER_STATE.ATTACK
    attack_timer = 0
    rand = irandom(2)

    var _inst = instance_create_depth(x, y, depth, oPlayerAttack )
    _inst.image_angle = player_to_cursor_angle

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

if (current_state != PLAYER_STATE.ATTACK) {
    if (is_moving) current_state = PLAYER_STATE.MOVING;
    else current_state = PLAYER_STATE.IDLE;
}

switch (current_state) {
    case PLAYER_STATE.IDLE:
        if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315) sprite_index = spr_player_idle_right
        else if (player_to_cursor_angle < 135) sprite_index = spr_player_idle_up
        else if (player_to_cursor_angle < 225) sprite_index = spr_player_idle_left
        else sprite_index = spr_player_idle_down
        break;
    case PLAYER_STATE.MOVING:
        if horizontal_movement > 0 sprite_index = spr_player_walk_right;
        if horizontal_movement < 0 sprite_index = spr_player_walk_left;
        if vertical_movement > 0 sprite_index = spr_player_walk_down;
        if vertical_movement < 0 sprite_index = spr_player_walk_up           
        break;
    case PLAYER_STATE.ATTACK:
        if (player_to_cursor_angle < 45 || player_to_cursor_angle >= 315) {
            sprite_index = spr_player_attack_right
        }
        else if (player_to_cursor_angle < 135) {
            sprite_index = spr_player_attack_up
        }
        else if (player_to_cursor_angle < 225) {
            sprite_index = spr_player_attack_left
        }
        else {
            if (rand == 0) sprite_index = spr_player_attack_down2
            else sprite_index = spr_player_attack_down
        }        
        break;
}

if (hp < max_hp && hp_timer >= hp_delay) {
    temp_hp += hp_regen
    if (temp_hp == 1) {
        temp_hp = 0
        hp++
    }
}
if (hp_timer <= hp_delay) hp_timer++



if (knockback_force > 0) {
    var knockback_decay = 0.5
    hspeed += lengthdir_x(knockback_force, knockback_dir);
    vspeed += lengthdir_y(knockback_force, knockback_dir);
    knockback_force -= knockback_decay;
    if (knockback_force < 0) knockback_force = 0;
}


hspeed *= 0.75;
vspeed *= 0.75;

// Clamp velocity
var max_speed = 4;
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

//if (!is_moving) {
//    switch (sprite_index) {
//        case spr_player_walk_right: sprite_index = spr_player_idle_right; break;
//        case spr_player_walk_left:  sprite_index = spr_player_idle_left; break;
//        case spr_player_walk_up:    sprite_index = spr_player_idle_up; break;
//        case spr_player_walk_down:  sprite_index = spr_player_idle_down; break;
//    }
//}

