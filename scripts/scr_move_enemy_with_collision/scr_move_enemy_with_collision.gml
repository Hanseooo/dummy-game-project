/// @function scr_move_enemy_with_collision(_mx, _my, tilemap)
/// @desc Checks all four corners of the sprite for a solid tile.
/// @param _x        Pixel X position to check
/// @param _y        Pixel Y position to check
/// @param _tilemap  Tilemap layer ID

function scr_move_enemy_with_collision(_mx, _my, tilemap) {
    // Horizontal movement
    if (!scr_tilemap_solid_at(x + _mx, y, tilemap)) {
        x += _mx;
    } else {
        _mx = 0;
    }

    // Vertical movement
    if (!scr_tilemap_solid_at(x, y + _my, tilemap)) {
        y += _my;
    } else {
        _my = 0;
    }
}
