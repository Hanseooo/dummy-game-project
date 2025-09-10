
attack_timer = min(attack_timer + 1, attack_cd);



switch (current_state) {
    case ENEMY_STATE.idle:
        state_counter++;
        if (state_counter >= game_speed*2) {
            state_counter = 0;
            current_state = choose(ENEMY_STATE.wander, ENEMY_STATE.idle);
        }
        if (collision_circle(x, y, 128, oPlayer, false, false) && stun_timer <= 0) {
            current_state = ENEMY_STATE.chase;
        }
        sprite_index = spr_dark_mage;
        break;

    case ENEMY_STATE.wander:
        state_counter++;
        scr_move_enemy_with_collision(move_x, move_y, tilemap);
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
        if (collision_circle(x, y, 128, oPlayer, false, false)) {
            current_state = ENEMY_STATE.chase;
        }
    
        scr_enemy_set_directional_sprite(move_x, move_y, spr_dark_mage, spr_dark_mage, 0.8)

        break;

    case ENEMY_STATE.chase:
        var ang  = point_direction(x, y, oPlayer.x, oPlayer.y);
        var dist = point_distance(x, y, oPlayer.x, oPlayer.y);
    
        // Attack if ready
        if (attack_timer >= attack_cd && dist <= 128) {
            current_state = ENEMY_STATE.attack;
            image_index   = 0;
            image_speed   = 1;
            image_xscale  = (ang > 90 && ang < 270) ? -0.8 : 0.8;
            attack_timer  = 0;
            break;
        }
    
    
        // Flee if too close
        if (dist < flee_range) {
            var flee_ang = ang + 180;
            move_x = lengthdir_x(move_speed, flee_ang);
            move_y = lengthdir_y(move_speed, flee_ang);
            scr_move_enemy_with_collision(move_x, move_y, tilemap);
            break;
        }
    
        // Normal chase
        move_x = lengthdir_x(move_speed, ang);
        move_y = lengthdir_y(move_speed, ang);
        scr_move_enemy_with_collision(move_x, move_y, tilemap)
        image_xscale = (ang > 90 && ang < 270) ? -0.8 : 0.8;
        break;

    case ENEMY_STATE.attack:
        sprite_index = spr_dark_mage_attack;
        var a = point_direction(x, y, oPlayer.x, oPlayer.y);
        image_xscale = (a > 90 && a < 270) ? -0.8 : 0.8;
        var px = x + lengthdir_x(16, a);
        var py = y + lengthdir_y(16, a);
    
        if (floor(image_index) >= 7) { // adjust to your anim length
            var rand = choose(0, 1)
            if (rand == 0) { 

            var side_offset = 8 * sign(image_xscale);
            var up_offset   = -6;
            px += side_offset;
            py += up_offset;
    
            var ball = instance_create_depth(px, py, depth, oShadowBall);
            ball.direction     = a;
            ball.speed         = 1.5;
            ball.range         = 256;
            ball.distance_trav = 0;
            ball.tilemap       = tilemap;
            ball.damage        = damage
            ball.owner = id
                attack_cd = game_speed * random_range(4, 7)
            }
            
            else {
                var rand2 = random_range(0, 6)
                var entity = noone
                if (rand2 <= 2) entity = oGreenSlime
                else if (rand2 == 5) entity = oDarkMage
                else entity = oSkeleton1
                    
                var mob = instance_create_depth(px, py, depth, entity)  
                mob.hp /= 2
                mob.image_blend = make_color_rgb(147, 112, 219)
                mob.damage = mob.damage >= 2 ? mob.damage / 2 : 1
                audio_play_sound(snd_stand_summon, 0, false)
                attack_cd = game_speed * choose(6, 8)
            }

    
            current_state = ENEMY_STATE.chase;
        }
        break;

}
    

    
if (hp <= 0 && current_state != ENEMY_STATE.dead) {
    current_state = ENEMY_STATE.dead;
    knockback_force += 0.2
    scr_hit_sparks(x, y, 14, knockback_dir)
    sprite_index = spr_dark_mage_death;
    //image_index = choose(-1, 1)
    //image_speed = 0.5; 
    image_index = 0;  
    alarm[1] = game_speed * 8;
}


if (abs(move_x) < 0.1 && abs(move_y) < 0.1) {
    scr_enemy_set_directional_sprite(move_x, move_y, spr_dark_mage, spr_dark_mage, 0.8);
}


if (current_state == ENEMY_STATE.dead && image_index >= image_number - 1) {
    image_speed = 0;
    image_index = image_number - 1;
}

if (fade_timer > 0) {
    fade_timer--;
    image_alpha = fade_timer / fade_duration; 
} else if (fade_timer == 0) {
    image_alpha = 0; 
}



if (alarm[1] == game_speed*3) {
    fade_timer = fade_duration
}

    
if (hit_registered && !hit_applied) {
    alarm[0] = 30
    apply_hit_effect(5, 1)
    scr_hit_sparks(x, y, 12, knockback_dir)
    hit_applied = true
    stun_timer = 15
    if(hit_flash_timer <= hit_flash_duration) hit_flash_timer = hit_flash_duration
    
    if (hp <= 0) {
        current_state = ENEMY_STATE.dead
    }
    
    if (current_state == ENEMY_STATE.dead && image_index >= image_number-1) {
        image_speed = 0
        image_index = image_number-1
    }
}

if (hit_flash_timer >= 0) hit_flash_timer--
    
if (stun_timer > 0) {
    stun_timer--
    
    if(knockback_force <= 0) current_state = ENEMY_STATE.idle
} else {
    // Normal behavior resumes
    // e.g., movement, chasing, attacking
}
    
// Apply knockback force (if any)
if (knockback_force > 0) {
    hspeed += lengthdir_x(knockback_force, knockback_dir);
    vspeed += lengthdir_y(knockback_force, knockback_dir);
    knockback_force -= knockback_decay;
    if (knockback_force < 0) knockback_force = 0;
}

// Apply friction
hspeed *= 0.85;
vspeed *= 0.85;

// Clamp velocity
var max_speed = 2
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
