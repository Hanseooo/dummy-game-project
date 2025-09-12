/// @function scr_find_tactical_spawn(mage_x, mage_y, player, tilemap, radius, samples)
/// @desc Finds a spawn point that avoids walls and is tactically placed.
/// @param mage_x   Mage X position
/// @param mage_y   Mage Y position
/// @param player   Player instance
/// @param tilemap  Tilemap ID
/// @param radius   Max search radius from mage
/// @param samples  Number of random points to test

function scr_find_tactical_spawn(mage_x, mage_y, player, tilemap, radius, samples) {
    var dist_to_player = point_distance(mage_x, mage_y, player.x, player.y);
    var ang_to_player  = point_direction(mage_x, mage_y, player.x, player.y);

    var target_x, target_y;

    if (dist_to_player > 96) {
        // Player is far → aim between mage and player
        target_x = mage_x + lengthdir_x(dist_to_player * 0.5, ang_to_player);
        target_y = mage_y + lengthdir_y(dist_to_player * 0.5, ang_to_player);
    } else {
        // Player is close → spawn behind mage
        var behind_angle = ang_to_player + 180;
        target_x = mage_x + lengthdir_x(48, behind_angle);
        target_y = mage_y + lengthdir_y(48, behind_angle);
    }

    var best_x = mage_x;
    var best_y = mage_y;
    var best_dist = 1 * 10^9;

    for (var i = 0; i < samples; i++) {
        var ang  = irandom(359);
        var dist = random_range(8, radius);
        var sx   = mage_x + lengthdir_x(dist, ang);
        var sy   = mage_y + lengthdir_y(dist, ang);

        if (!scr_tilemap_solid_at(sx, sy, tilemap)) {
            var d_to_target = point_distance(sx, sy, target_x, target_y);
            if (d_to_target < best_dist) {
                best_dist = d_to_target;
                best_x = sx;
                best_y = sy;
            }
        }
    }

    return [best_x, best_y];
}