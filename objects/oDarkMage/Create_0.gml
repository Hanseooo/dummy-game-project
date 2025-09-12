hp = 2
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

move_speed = 0.5
enemy_direction = random_range(0, 359)
move_x = lengthdir_x(move_speed, enemy_direction)
move_y = lengthdir_y(move_speed, enemy_direction)

my_attack =  noone
attack_cd = game_speed * random_range(4, 6)
attack_timer = 0
attack_knockback = 5

flee_range = 96

can_drop_item = true



image_xscale = 0.8
image_yscale = 0.8



function apply_hit_effect(duration, alarm_index) {
    alarm[alarm_index] = duration;
    audio_sound_pitch(snd_sword_strikes_object,irandom_range(1.2, 1.5))
    audio_play_sound(snd_sword_strikes_object, 0, false)
    //image_blend = flash_color;
}

/// Helper: find a safe spawn position away from walls
function find_safe_spawn(x0, y0, tilemap, tries, radius) {
    var sx = x0;
    var sy = y0;

    for (var i = 0; i < tries; i++) {
        // If current spot is free, return it
        if (!scr_tilemap_solid_at(sx, sy, tilemap)) {
            return [sx, sy];
        }

        // Otherwise, try a random offset within radius
        var ang = irandom(359);
        var dist = random_range(8, radius);
        sx = x0 + lengthdir_x(dist, ang);
        sy = y0 + lengthdir_y(dist, ang);
    }

    // If all tries fail, return original position
    return [x0, y0];
}



