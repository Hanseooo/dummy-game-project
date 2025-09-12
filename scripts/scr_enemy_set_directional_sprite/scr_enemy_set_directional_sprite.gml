/// scr_enemy_set_directional_sprite()
/// @desc sets the sprite direction
/// @param source_x Pixel x position
/// @param source_y Pixel y position
/// @param idle_sprite sprite
/// @param walk_sprite sprite
/// @param scale number size of sprite


function scr_enemy_set_directional_sprite(source_x, source_y, idle_sprite, walk_sprite, scale) {
    if (abs(source_x) < 0.1 && abs(source_y) < 0.1) {
    sprite_index  = idle_sprite;  
    image_xscale  = choose(-0.8, 0.8);
    return;
    }
    var dir = point_direction(0, 0, source_x, source_y);
    sprite_index   = walk_sprite;
    image_xscale   = (dir >= 270 || dir <= 90) ? scale : scale;
}