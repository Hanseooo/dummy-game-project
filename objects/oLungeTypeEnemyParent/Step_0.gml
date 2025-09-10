/// — 1) Attack cooldown  
attack_timer = min(attack_timer + 1, attack_cd);

/// — 2) State machine  
switch (current_state) {

    case ENEMY_STATE.idle:
        state_counter++;
        if (state_counter >= game_speed*3) {
            state_counter = 0;
            current_state = choose(ENEMY_STATE.wander, ENEMY_STATE.idle);
        }
        if (collision_circle(x, y, 96, oPlayer, false, false) && stun_timer <= 0) {
            current_state = ENEMY_STATE.chase;
        }
        sprite_index = spr_skeleton1_idle;  // child override
        break;

    case ENEMY_STATE.wander:
        state_counter++;
        scr_move_enemy_with_collision(move_x, move_y, tilemap);
        scr_enemy_set_directional_sprite(move_x, move_y, spr_skeleton1_idle, spr_skeleton1_walk, 0.8);  
        if (state_counter >= game_speed*2) {
            state_counter = 0;
            if (choose(0,1) == 0) {
                current_state = ENEMY_STATE.idle;
            } else {
                var dir = random_range(0,359);
                move_x = lengthdir_x(move_speed, dir);
                move_y = lengthdir_y(move_speed, dir);
            }
        }
        if (collision_circle(x, y, 96, oPlayer, false, false)) {
            current_state = ENEMY_STATE.chase;
        }
        break;

    case ENEMY_STATE.chase:
        var ang = point_direction(x, y, oPlayer.x, oPlayer.y);
        move_x = lengthdir_x(move_speed, ang);
        move_y = lengthdir_y(move_speed, ang);
        scr_move_enemy_with_collision(move_x, move_y, tilemap);
        scr_enemy_set_directional_sprite();
        if (!collision_circle(x, y, 96, oPlayer, false, false)) {
            current_state = ENEMY_STATE.idle;
            break;
        }
        if (point_distance(x, y, oPlayer.x, oPlayer.y) <= 16) {
            current_state   = ENEMY_STATE.melee;
            sprite_index    = spr_skeleton1_attack;
            image_xscale    = (ang > 90 && ang < 270) ? -0.8 : 0.8;
            image_index     = 9;
            image_speed     = 1;
            break;
        }
        if (collision_circle(x, y, 42, oPlayer, false, false) && attack_timer >= attack_cd) {
            attack_timer   = 0;
            attack_cd      = irandom_range(1,5) * game_speed;
            current_state  = ENEMY_STATE.attack;
            dash_phase     = 0;
            dash_traveled  = 0;
            sprite_index   = spr_skeleton1_attack;
            image_xscale   = (ang > 90 && ang < 270) ? -0.8 : 0.8;
            image_index    = 0;
            image_speed    = 1;
        }
        break;

    case ENEMY_STATE.melee:
        if (floor(image_index) >= image_number - 1) {
            current_state = ENEMY_STATE.chase;
        }
        break;

    case ENEMY_STATE.attack:
        // — Phase 0 → 1 (wind-up)
        if (dash_phase == 0) {
            dash_phase = 1;  
            break;
        }

        // — Phase 1 → 2 (after frame 7)
        if (dash_phase == 1) {
            if (floor(image_index) < 7) break;
            dash_phase = 2;
            var a = point_direction(x, y, oPlayer.x, oPlayer.y);
            dash_dir_x = lengthdir_x(1, a);
            dash_dir_y = lengthdir_y(1, a);

            // dynamic friction
            var dist = point_distance(x, y, oPlayer.x, oPlayer.y);
            dash_friction = lerp(0.8, dash_friction_initial, clamp(dist/24,0,1));

            // dynamic anim speed
            var maxDist      = 96;
            var norm         = clamp((maxDist - dist)/maxDist, 0,1);
            image_speed      = lerp(1, 3, norm);

            break;
        }

        // — Phase 2: actual dash
        if (dash_phase == 2) {
            var facing = point_direction(x, y, oPlayer.x, oPlayer.y);
            image_xscale = (facing > 90 && facing < 270) ? -0.8 : 0.8;
            var vx = dash_dir_x*dash_speed, vy = dash_dir_y*dash_speed;
            var steps = max(1, ceil(max(abs(vx),abs(vy))));
            var sx = vx/steps, sy = vy/steps;
            for (var i=0; i<steps; i++) {
                if (!place_meeting(x+sx, y, tilemap)) x += sx; else sx = 0;
                if (!place_meeting(x, y+sy, tilemap)) y += sy; else sy = 0;
            }
            dash_traveled += point_distance(0,0,vx,vy);
            dash_speed    *= dash_friction;
            if (floor(image_index) >= image_number -1) image_speed = 0;

            if (dash_traveled >= dash_distance || dash_speed < 1 || (sx==0 && sy==0)) {
                dash_phase = 0;
                dash_speed = dash_speed_initial;
                current_state = ENEMY_STATE.chase;
            }
        }
        break;

    case ENEMY_STATE.dead:
        // handled below
        break;
}

/// — 3) Hit registration & stun  
if (hit_registered && !hit_applied) {
    apply_hit_effect(5, 1);
    scr_hit_sparks(x, y, 12, knockback_dir);
    hit_applied    = true;
    stun_timer     = 15;
    alarm[0]       = 30;
    if (hp <= 0) current_state = ENEMY_STATE.dead;
}

/// — 4) Stun countdown  
if (stun_timer > 0) {
    stun_timer--;
    if (knockback_force <= 0) current_state = ENEMY_STATE.idle;
}

/// — 5) Knockback & friction  
if (knockback_force > 0) {
    hspeed += lengthdir_x(knockback_force, knockback_dir);
    vspeed += lengthdir_y(knockback_force, knockback_dir);
    knockback_force -= knockback_decay;
}
hspeed *= 0.85;  
vspeed *= 0.85;  

/// — 6) Movement w/ collision  
if (!scr_tilemap_solid_at(x+hspeed, y, tilemap))      x += hspeed; else hspeed = 0;  
if (!scr_tilemap_solid_at(x, y+vspeed, tilemap))      y += vspeed; else vspeed = 0;  

/// — 7) Death & fade  
if (hp <= 0 && current_state != ENEMY_STATE.dead) {
    current_state = ENEMY_STATE.dead;
    sprite_index  = spr_skeleton1_death;  // child override
    image_speed   = 0.5;
    image_index   = 0;
    alarm[1]      = game_speed*5;
}

if (fade_timer > 0) {
    fade_timer--;
    image_alpha = fade_timer / fade_duration;
} else if (fade_timer == 0) {
    image_alpha = 0;
}

/// — 8) Zoom back anim  
if (zoom_target > 1 && dash_phase==0 && stun_timer<=0) {
    zoom_target = 1;
}