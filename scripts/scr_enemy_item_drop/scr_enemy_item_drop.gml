/// @function scr_enemy_item_drop(move_x, move_y, item, percentage, depth, [min_quantity=1], [max_quantity=1])
/// @desc Allows enemies to drop items with optional quantity range and natural scatter.
/// @param move_x        Pixel x position
/// @param move_y        Pixel y position
/// @param item          Object to drop
/// @param percentage    Chance (0–100) to drop each item
/// @param depth         Depth of the created instance
/// @param [min_quantity] Optional: minimum quantity to drop (default 1)
/// @param [max_quantity] Optional: maximum quantity to drop (default 1)

function scr_enemy_item_drop(move_x, move_y, item, percentage, depth, min_quantity = 1, max_quantity = 1) {
    var quantity = irandom_range(min_quantity, max_quantity);

    for (var i = 0; i < quantity; i++) {
        if (random(100) < percentage) {
            // Scatter offset: random direction and distance
            var ang  = irandom(359);
            var dist = random_range(4, 12); // tweak for more/less spread
            var drop_x = move_x + lengthdir_x(dist, ang);
            var drop_y = move_y + lengthdir_y(dist, ang);

            instance_create_depth(drop_x, drop_y, depth, item);
        }
    }
}