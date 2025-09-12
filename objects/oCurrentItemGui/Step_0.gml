if (!instance_exists(player)) exit;

hover_timer += 0.05;

// Pulse when quantity changes
var qty = global.item_data[player.current_item].get_quantity();
if (qty != last_qty) {
    pulse_scale = 1.3; // start pulse
    last_qty = qty;
}

// Smoothly return pulse scale to 1
if (pulse_scale > 1) pulse_scale = max(1, pulse_scale - pulse_speed);