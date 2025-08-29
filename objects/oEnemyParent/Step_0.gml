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
    
        if (collision_circle(x, y, 64, oPlayer, false, false)) {
            current_state = ENEMY_STATE.chase
        }
    
        sprite_index = spr_greenslime_idle
    
        break
    case ENEMY_STATE.wander:
        state_counter++
        x += move_x
        y += move_y
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
    if collision_circle(x, y, 64, oPlayer, false, false) {
        current_state = ENEMY_STATE.chase
    }
        
        break
    case ENEMY_STATE.chase:
        enemy_direction = point_direction(x, y, oPlayer.x, oPlayer.y)
        move_x = lengthdir_x(move_speed, enemy_direction)
        move_y = lengthdir_y(move_speed, enemy_direction)
        x += move_x
        y += move_y
        if (!collision_circle(x, y, 64, oPlayer, false, false)) {
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
}

if (attack_timer <= attack_cd) attack_timer++