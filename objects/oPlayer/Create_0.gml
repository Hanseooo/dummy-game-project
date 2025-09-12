    move_speed = 1
    is_slowed = false
    
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
    attack_cd = game_speed * 0.35
    attack_timer = game_speed * 0.35
    attack_sprite = noone
    // combo
    combo_step         = 0;      // 0=none, 1..3 active segment
    combo_timer        = 0;      // frames left to continue chain
    combo_window       = game_speed * 0.5;
    combo_next_queued  = false;  // queued next hit by click during current segment
    attack_end_frame   = 0;      // last frame index of current segment
    // Dash system
    dash_remaining     = 0;
    dash_target        = noone;
    dash_stop_dist     = 0;
    dash_distance      = 32
    did_dash_for_hit = false
    hspeed             = 0;
    vspeed             = 0;


    
roll_timer = 0
roll_cd = 30
roll_stamina_consumption = 4
roll_distance = 36
roll_speed = 2
roll_traveled = 0;    
roll_dir_x = 0;
roll_dir_y = 0;
roll_sprite = noone;

health_potion = 2
max_health_potion_amount = 3

// Store reference to effects controller
effects_controller = instance_find(oPlayerEffectsController, 0);



with(oCamera) {
    target = other
}


tilemap = layer_tilemap_get_id("Tiles_Wall")

enum PLAYER_STATE  {
    IDLE = 0, MOVING = 1 , ATTACK = 2, ROLLING = 3,
}
enum PLAYER_ITEM {
    health_potion,
}

current_item = PLAYER_ITEM.health_potion

is_moving = false
current_state = PLAYER_STATE.IDLE
rand = irandom(2)

bar_width = 100
bar_height = 22




function player_take_damage(source) {
    hp -= source.damage
    hit_flash = true
    audio_sound_pitch(snd_hit_effect, irandom_range(1, 1.2))
    audio_play_sound(snd_hit_effect, 0, false)
    scr_hit_sparks(x, y, 12, knockback_dir)
    with(oCamera) {
        shake_time = 12
        shake_strength = 5
        zoom_target = 1.15
    }
    alarm[1] = 10
    if hp <= 0 {
        room_restart()
        //alarm[2] = 60
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

function apply_slow_effect(duration, slow_ratio) {
    alarm[3] = game_speed * duration
    move_speed = move_speed * slow_ratio
    is_slowed = true
}


item_cooldown = 0; // frames remaining until next use
item_cooldown_max = game_speed * 3; // 1 second cooldown

function useItem() {
    if (item_cooldown > 0) return; // still cooling down

    switch(current_item) {
        case PLAYER_ITEM.health_potion:
            if (health_potion >= 1 && hp < max_hp) {
                health_potion--;
                hp += hp == max_hp - 1 ? 1 : 2;
                
                with (oPlayerEffectsController) {
                    heal_effect_active = true;
                    heal_effect_frame  = 0;
                }
            }
            break;
    }

    // Start cooldown after any item use
    item_cooldown = item_cooldown_max;
}

/// Start a combo hit (1..3)
function start_combo_hit(step) {
    current_state = PLAYER_STATE.ATTACK;
    attack_timer  = 0;
    combo_timer   = combo_window;
    did_dash_for_hit = false;

    var dir    = point_direction(x, y, mouse_x, mouse_y);
    var flip_h = false;

    if (dir < 45 || dir >= 315) {
        attack_sprite = spr_player_attack_side;
    } else if (dir < 135) {
        attack_sprite = spr_player_attack_up;
    } else if (dir < 225) {
        attack_sprite = spr_player_attack_side; flip_h = true;
    } else {
        attack_sprite = spr_player_attack_down;
    }

    var start_frame = (step - 1) * 3;
    var end_frame   = start_frame + 3;
    var total       = sprite_get_number(attack_sprite);
    start_frame     = clamp(start_frame, 0, total - 1);
    end_frame       = clamp(end_frame,   0, total - 1);

    sprite_index     = attack_sprite;
    image_xscale     = flip_h ? -1 : 1;
    image_index      = start_frame;
    image_speed      = 1; // plays at sprite's FPS (set to 10 in editor)
    attack_end_frame = end_frame;

    audio_sound_pitch(snd_sword_swoosh, random_range(1, 1.5));
    audio_play_sound(snd_sword_swoosh, 0, false);

    var _hit = instance_create_depth(x, y, depth, oPlayerAttack);
    _hit.image_angle = dir;
    _hit.owner       = id;
}

/// @function find_dash_target(_radius)
/// @desc Returns the nearest enemy to the cursor that is also within _radius of the player
///       and is NOT in ENEMY_STATE.dead.
function find_dash_target(_radius) {
    var best_target = noone;
    var best_dist_to_cursor = 1000000000;

    with (oEnemyParent) {
        if (current_state != ENEMY_STATE.dead
        && point_distance(other.x, other.y, x, y) <= _radius) {
            var dist_cursor = point_distance(mouse_x, mouse_y, x, y);
            if (dist_cursor < best_dist_to_cursor) {
                best_dist_to_cursor = dist_cursor;
                best_target = id;
            }
        }
    }
    return best_target;
}

//dash toward
function dash_toward(_target, _max_dist, _extra_buffer) {
    if (_target == noone) return;

    // Calculate mask radius from enemy's collision mask
    var mask_radius = max(
        abs(_target.bbox_right  - _target.x),
        abs(_target.bbox_left   - _target.x),
        abs(_target.bbox_bottom - _target.y),
        abs(_target.bbox_top    - _target.y)
    );

    dash_target    = _target;
    dash_stop_dist = mask_radius + _extra_buffer;

    var dist_to_target = point_distance(x, y, _target.x, _target.y);
    if (dist_to_target <= dash_stop_dist) {
        dash_remaining = 0;
        return;
    }

    var dash_len = min(_max_dist, max(0, dist_to_target - dash_stop_dist));
    var ddir     = point_direction(x, y, _target.x, _target.y);

    var dash_speed = 1.25; // tweak for feel
    hspeed = lengthdir_x(dash_speed, ddir);
    vspeed = lengthdir_y(dash_speed, ddir);

    dash_remaining = dash_len;
}