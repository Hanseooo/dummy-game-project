hp = 3
damage = 1

hit_registered = false
hit_applied = false
stun_timer = 0

knockback_dir = 0;
knockback_force = 0;
knockback_decay = 0.5;

target_x = x
target_y = y

game_speed = 60

my_attack = noone
attack_cd = 45
attack_timer = 0
attack_knockback = 2

tilemap = layer_tilemap_get_id("Tiles_Wall")

enum ENEMY_STATE {
	idle = 0,
    wander = 1,
    chase = 2,
    attack = 3,
    melee = 4,
    dead = 5,
}

state_counter = 0
current_state = ENEMY_STATE.idle

move_speed = 0.75
enemy_direction = random_range(0, 359)
move_x = lengthdir_x(move_speed, enemy_direction)
move_y = lengthdir_y(move_speed, enemy_direction)

function apply_hit_effect(duration, flash_color, alarm_index) {
    alarm[alarm_index] = duration;
    image_blend = flash_color;
}

