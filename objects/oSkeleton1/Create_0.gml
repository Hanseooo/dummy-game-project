hp = 6
damage = 1

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

move_speed = 0.7
enemy_direction = random_range(0, 359)
move_x = lengthdir_x(move_speed, enemy_direction)
move_y = lengthdir_y(move_speed, enemy_direction)

my_attack =  noone
attack_cd = 4
attack_timer = 0
attack_knockback = 3

/// Dash & Attack wind-up settings
dash_distance       = 180;      // total pixels to lunge (past the player)
dash_speed          = 4.5;      // initial dash speed (pixels/frame)
dash_friction       = 0.95;    // velocity multiplier each frame
attack_pause_time   = 24;      // wind-up in frames

/// Runtime trackers
dash_phase          = 0;       // 0=none, 1=pausing, 2=dashing
dash_pause_timer    = 0;
dash_traveled       = 0;
dash_dir_x          = 0;
dash_dir_y          = 0;

dash_phase            = 0;
dash_speed_initial    = dash_speed; // remember the default
dash_friction_initial = dash_friction;


function set_directional_sprite() {

    if (abs(move_x) < 0.1 && abs(move_y) < 0.1) {
        sprite_index = spr_skeleton1_idle;
        image_xscale = choose(-1, 1);
        return;
    }

    var dir = point_direction(0, 0, move_x, move_y);


    sprite_index = spr_skeleton1_walk;

    if (dir >= 270 || dir <= 90) {
        image_xscale = 1;  
    } else {
        image_xscale = -1; 
    }
}

function apply_hit_effect(duration, alarm_index) {
    alarm[alarm_index] = duration;
    audio_sound_pitch(snd_sword_strikes_object,random_range(0.8, 1.2))
    audio_play_sound(snd_sword_strikes_object, 0, false)
    //image_blend = flash_color;
}



