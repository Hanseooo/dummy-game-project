move_speed = 1

game_speed = 60

hp = 5
max_hp = 5
hp_regen = 0.0025
temp_hp = 0
hp_timer = 0
hp_delay = 5 * game_speed

is_invincible = false
knockback_force = 0;
knockback_dir = 0;


damage_multiplier = 1
attack_cd = 35
attack_timer = 35

tilemap = layer_tilemap_get_id("Tiles_Wall")

enum PLAYER_STATE  {
    IDLE = 0, MOVING = 1 , ATTACK = 2
}

is_moving = false
current_state = PLAYER_STATE.IDLE
rand = irandom(2)

bar_width = 100
bar_height = 22




function player_take_damage(source) {
    hp -= source.damage
    is_invincible = true
    alarm[0] = 30
    
    if hp <= 0 {
        room_restart()
    }
    hp_timer = 0
}

function apply_knockback(source, force) {
    knockback_dir = point_direction(source.x, source.y, x, y);
    knockback_force = force;
    
    
}
