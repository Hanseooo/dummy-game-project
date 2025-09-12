player = instance_find(oPlayer, 0); // link to player
hover_timer = 0;
pulse_scale = 1;
pulse_speed = 0.05;
last_qty = -1;

/// @function draw_pie_sector(x, y, radius, angle_start, angle_end)
/// @desc Draws a filled pie slice (sector) between two angles.
function draw_pie_sector(_x, _y, _r, _a1, _a2) {
    var precision = 32; // more = smoother
    var ang1 = degtorad(_a1);
    var ang2 = degtorad(_a2);
    var step = (ang2 - ang1) / precision;

    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_x, _y);
    for (var i = 0; i <= precision; i++) {
        var ang = ang1 + step * i;
        draw_vertex(_x + lengthdir_x(_r, radtodeg(ang)), _y + lengthdir_y(_r, radtodeg(ang)));
    }
    draw_primitive_end();
}