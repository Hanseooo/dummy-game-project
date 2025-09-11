switch (current_state) {
	case ENEMY_STATE.idle:
        state_counter++
    
        if (state_counter >= game_speed*3) {
            var change = choose(0, 1)
            switch (change) {
            	case 0: current_state = ENEMY_STATE.wander
                case 1: state_counter = 0; break
            }
        }
    
        if (collision_circle(x, y, 96, oPlayer, false, false) && stun_timer <= 0) {
            current_state = ENEMY_STATE.chase
        }
    
        sprite_index = spr_greenslime_idle
    
        break
    case ENEMY_STATE.wander:
        state_counter++
        scr_move_enemy_with_collision(move_x, move_y, tilemap)
        image_speed = 0.8
        move_speed = 0.3
        set_directional_sprite()
        if (state_counter >= game_speed*2) {
            var change = choose(0, 1)
            switch (change) {
            	case 0: current_state = ENEMY_STATE.idle
                case 1: state_counter = 0;
                    enemy_direction = random_range(0, 359)
                    move_x = lengthdir_x(move_speed, enemy_direction)
                    move_y = lengthdir_y(move_speed, enemy_direction)
                    break;
            }
        }
    if collision_circle(x, y, 96, oPlayer, false, false) {
        current_state = ENEMY_STATE.chase
    }
        
        break
    case ENEMY_STATE.chase:
        enemy_direction = point_direction(x, y, oPlayer.x, oPlayer.y)
        move_x = lengthdir_x(move_speed, enemy_direction)
        move_y = lengthdir_y(move_speed, enemy_direction)
        scr_move_enemy_with_collision(move_x, move_y, tilemap)
        image_speed = 1.25
        move_speed = 0.5
        set_directional_sprite()
        if (!collision_circle(x, y, 96, oPlayer, false, false)) {
            current_state = ENEMY_STATE.idle
        }
        if (collision_circle(x, y, 8, oPlayer, false, false) && attack_timer >= attack_cd) {
            attack_timer = 0
            current_state = ENEMY_STATE.attack
        }
        break
    case ENEMY_STATE.attack:
        if(my_attack == noone) {
            var facing = point_direction(x, y, oPlayer.x, oPlayer.y)
            my_attack = instance_create_depth(x, y, depth, oGreenSlimeAttack)
            my_attack.creator = id
            my_attack.image_angle = facing
            my_attack.damage = damage
        }
        my_attack = noone
        current_state = ENEMY_STATE.chase
        break
    case ENEMY_STATE.dead:
        break

}

if (attack_timer <= attack_cd) attack_timer++
    
if (hp <= 0 && current_state != ENEMY_STATE.dead) {
    current_state = ENEMY_STATE.dead;
    knockback_force += 0.2
    
    scr_enemy_item_drop(move_x, move_y, OHealthPotion, 0, 15)
    
    scr_hit_sparks(x, y, 14, knockback_dir)
    sprite_index = spr_greenslime_dead;
    image_speed = 0.5; 
    image_index = 0;  
    alarm[1] = game_speed * 5;
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
