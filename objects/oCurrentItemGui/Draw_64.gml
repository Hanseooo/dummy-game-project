if (!instance_exists(player)) exit;
if (is_undefined(global.item_data) || is_undefined(global.item_data[player.current_item])) exit;

var margin = 54;
var radius = 32;
var x_pos = margin;
var y_pos = display_get_gui_height() - margin;

var item_info = global.item_data[player.current_item];
var spr = item_info.sprite;
var qty = item_info.get_quantity();
var draw_radius = radius * pulse_scale;

// --------------------
// 1. Circular semi‑transparent black background
// --------------------
draw_set_alpha(0.5);
draw_set_color(c_black);
draw_circle(x_pos, y_pos, draw_radius, false);
draw_set_alpha(1);

// --------------------
// Player sprite (top half only, shifted down)
// --------------------
if (player.sprite_index != noone) {
    var pw = sprite_get_width(player.sprite_index);
    var ph = sprite_get_height(player.sprite_index);
    var crop_y = ph * 0.8; // only top half
    var player_scale = (draw_radius * 2.25) / max(pw, ph); // fill circle

    // Shift down to reveal more body
    var vertical_offset = draw_radius * 0.005; // tweak this value to taste

    draw_sprite_part_ext(
        player.sprite_index, player.image_index,
        0, 0, pw, crop_y, // source rect (top half)
        x_pos - (pw * player_scale) / 2,
        (y_pos - (crop_y * player_scale) / 2) + vertical_offset,
        player_scale, player_scale,
        c_white, 1
    );
}


// --------------------
// 3. Item sprite overlay
// --------------------
if (spr != noone) {
    var scale = (draw_radius * 1.5) / max(sprite_get_width(spr), sprite_get_height(spr));
    if (qty <= 0) draw_set_alpha(0.4); else draw_set_alpha(1);
    draw_sprite_ext(spr, 0, x_pos, y_pos, scale, scale, 0, c_white, 1);
    draw_set_alpha(1);
}

// --------------------
// 4. Radial cooldown wipe (custom function)
// --------------------
if (player.item_cooldown > 0) {
    var cd_ratio = player.item_cooldown / player.item_cooldown_max;
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_pie_sector(x_pos, y_pos, draw_radius, -90, -90 + (cd_ratio * 360));
    draw_set_alpha(1);
}

// --------------------
// 5. Quantity text
// --------------------
//draw_set_font(fnt_default);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x_pos, y_pos + draw_radius + 12, string(qty));