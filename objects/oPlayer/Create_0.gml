move_speed = 1

game_speed = 60

hp = 5
max_hp = 5
hp_regen = 0.0025
temp_hp = 0
hp_timer = 0
hp_delay = 5 * game_speed

stamina = 20
max_stamina = 20
stamina_regen = 0.005

pulse_timer = 0;
pulse_interval = 10;
pulse_alpha_state = 1;


is_invincible = false
knockback_force = 0;
knockback_dir = 0;

hit_flash = false


damage_multiplier = 1
attack_cd = 35
attack_timer = 35
attack_sprite = noone

roll_timer = 0
roll_cd = 30
roll_stamina_consumption = 4
roll_distance = 36
roll_speed = 2
roll_traveled = 0;    
roll_dir_x = 0;
roll_dir_y = 0;
roll_sprite = noone;


tilemap = layer_tilemap_get_id("Tiles_Wall")

enum PLAYER_STATE  {
    IDLE = 0, MOVING = 1 , ATTACK = 2, ROLLING = 3,
}

is_moving = false
current_state = PLAYER_STATE.IDLE
rand = irandom(2)

bar_width = 100
bar_height = 22




function player_take_damage(source) {
    hp -= source.damage
    hit_flash = true
    audio_sound_pitch(snd_hit_effect, random_range(0.8, 1.2))
    audio_play_sound(snd_hit_effect, 0, false)
    scr_hit_sparks(x, y, 12, knockback_dir)
    alarm[1] = 10
    if hp <= 0 {
        room_restart()
    }
    set_invincibility_duration(game_speed*2)
    start_pulse(game_speed*2)
    hp_timer = 0
}

function apply_knockback(source, force) {
    knockback_dir = point_direction(source.x, source.y, x, y);
    knockback_force = force;
    
    
}

function set_invincibility_duration(duration) {
    is_invincible = true
    alarm[0] = duration
}

function start_pulse(duration) {
    pulse_timer = duration;
    pulse_alpha_state = 1;
}



