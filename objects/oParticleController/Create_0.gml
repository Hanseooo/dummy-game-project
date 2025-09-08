/// @function scr_hit_sparks(_x, _y, _amt, _dir)
/// @param {real} _x     X position
/// @param {real} _y     Y position
/// @param {real} _amt   Number of particles
/// @param {real} _dir   Knockback direction (degrees)

function scr_hit_sparks(_x, _y, _amt, _dir) {

    // Safety net: create system/type if missing
    if (!variable_global_exists("hit_psys")) {
        global.hit_psys = part_system_create();
    }
    if (!variable_global_exists("hit_ptype")) {
        global.hit_ptype = part_type_create();
        part_type_shape   (global.hit_ptype, pt_shape_disk);
        part_type_size    (global.hit_ptype, 0.02, 0.05, 0, 0.002);   // your size
        part_type_color1  (global.hit_ptype, c_white);
        part_type_alpha2  (global.hit_ptype, 1, 0.5);             // your alpha fade
        part_type_speed   (global.hit_ptype, 1.25, 3, -0.075, 0.15);   // small decel + wiggle
        part_type_life    (global.hit_ptype, 15, 30);              // your life
    }

    // Direction: cone around knockback dir with randomness
    var spread = random_range(25, 45); // wider cone than before
    var min_dir = (_dir - spread + 360) mod 360;
    var max_dir = (_dir + spread + 360) mod 360;
    var ang_inc = 0;                   // no steady rotation
    var ang_wiggle = 10;               // jitter inside cone

    part_type_direction(global.hit_ptype, min_dir, max_dir, ang_inc, ang_wiggle);

    // Optional: offset spawn slightly behind and sideways for depth
    var back_offset = 0;
    var side_jitter = 0;
    var px = _x - lengthdir_x(back_offset, _dir) + lengthdir_x(side_jitter, _dir + 90);
    var py = _y - lengthdir_y(back_offset, _dir) + lengthdir_y(side_jitter, _dir + 90);

    // Spawn particles
    part_particles_create(global.hit_psys, px, py, global.hit_ptype, _amt);
}