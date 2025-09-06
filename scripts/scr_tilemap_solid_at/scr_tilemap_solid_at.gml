/// @function scr_tilemap_solid_at(_x, _y, _tilemap)
/// @desc Checks all four corners of the sprite for a solid tile.
/// @param _x        Pixel X position to check
/// @param _y        Pixel Y position to check
/// @param _tilemap  Tilemap layer ID

function scr_tilemap_solid_at(_x, _y, _tilemap) {
    var half_w = sprite_width * 0.5;
    var half_h = sprite_height * 0.5;

    // Offsets for the four corners
    var offsets = [
        [-half_w, -half_h], // top-left
        [ half_w, -half_h], // top-right
        [-half_w,  half_h], // bottom-left
        [ half_w,  half_h]  // bottom-right
    ];

    // Loop through each corner and check for a tile
    for (var i = 0; i < array_length(offsets); i++) {
        var ox = offsets[i][0];
        var oy = offsets[i][1];
        if (tilemap_get_at_pixel(_tilemap, _x + ox, _y + oy) != 0) {
            return true;
        }
    }

    return false;
}