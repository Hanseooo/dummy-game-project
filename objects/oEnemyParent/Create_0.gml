hp = 3
damage = 1

target_x = x
target_y = y

game_speed = 60

my_attack = noone
attack_cd = 45
attack_timer = 0

tilemap = layer_tilemap_get_id("Tiles_Wall")

enum ENEMY_STATE {
	idle = 0,
    wander = 1,
    chase = 2,
    attack = 3,
}

state_counter = 0
current_state = ENEMY_STATE.idle

move_speed = 0.75
enemy_direction = random_range(0, 359)
move_x = lengthdir_x(move_speed, enemy_direction)
move_y = lengthdir_y(move_speed, enemy_direction)