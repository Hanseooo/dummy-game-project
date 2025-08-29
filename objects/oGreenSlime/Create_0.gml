hp = 3
damage = 1

target_x = x
target_y = y

game_speed = 60



tilemap = layer_tilemap_get_id("Tiles_Wall")


state_counter = 0
current_state = ENEMY_STATE.idle

move_speed = 0.6
enemy_direction = random_range(0, 359)
move_x = lengthdir_x(move_speed, enemy_direction)
move_y = lengthdir_y(move_speed, enemy_direction)

my_attack =  noone
attack_cd = 60
attack_timer = 0

image_xscale = 0.75
image_yscale = 0.75
