hp = 4
damage = 2

hit_registered = false
hit_applied = false
hit_flash_timer = 0
hit_flash_duration = 10

stun_timer = 0

knockback_dir = 0;
knockback_force = 0;
knockback_decay = 0.5;



target_x = x
target_y = y

game_speed = 60

fade_duration = game_speed * 2;
fade_timer = -1;  



tilemap = layer_tilemap_get_id("Tiles_Wall")


state_counter = 0
current_state = ENEMY_STATE.idle

move_speed = 0.3
image_speed = 0.8
enemy_direction = random_range(0, 359)
move_x = lengthdir_x(move_speed, enemy_direction)
move_y = lengthdir_y(move_speed, enemy_direction)

my_attack =  noone
attack_cd = 60
attack_timer = 0
attack_knockback = 2

image_xscale = 0.75
image_yscale = 0.75

function set_directional_sprite() {
    var dir = point_direction(0, 0, move_x, move_y);

    if (abs(move_x) < 0.1 && abs(move_y) < 0.1) {
        sprite_index = spr_greenslime_idle;
        return;
    }

    if (dir >= 45 && dir < 135) {
        sprite_index = spr_greenslime_move_up;
    } else if (dir >= 135 && dir < 225) {
        sprite_index = spr_greenslime_move_left;
    } else if (dir >= 225 && dir < 315) {
        sprite_index = spr_greenslime_move_down;
    } else {
        sprite_index = spr_greenslime_move_right;
    }
}

function apply_hit_effect(duration, alarm_index) {
    alarm[alarm_index] = duration;
    audio_sound_pitch(snd_sword_strikes_object,random_range(0.8, 1.2))
    audio_play_sound(snd_sword_strikes_object, 0, false)
    //image_blend = flash_color;
}



