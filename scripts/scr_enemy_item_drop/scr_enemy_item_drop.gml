/// function scr_enemy_item_drop(move_x, move_y, item, min, max)
/// @desc allows enemies to drop items
/// @param move_x Pixel x position
/// @param move_y Pixel y position
/// @param item object
/// @param min number min value for random number generation
/// @param max number max value for random number generation


function scr_enemy_item_drop(move_x, move_y, item, min, max){
    var rand = floor(random_range(0, 9))
    if (rand == 1) instance_create_depth(move_x, move_y, depth, item)
}