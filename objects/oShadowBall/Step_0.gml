/// oShadowBall Step

/// // Accelerate until max speed is reached
if (speed < max_speed) {
    speed = min(speed + accel, max_speed);
}

// Move
var dx = lengthdir_x(speed, direction);
var dy = lengthdir_y(speed, direction);
x += dx;
y += dy;

// Rotate sprite to match travel direction
image_angle = direction; // +90 if your sprite points up

// Accumulate traveled distance
distance_trav += point_distance(0, 0, dx, dy);

// Self-destruct when out of range
if (distance_trav >= range) {
    instance_destroy();
    exit;
}

// Check wall collision
// Check wall collision
if (place_meeting(x, y, tilemap)) {

    // Move back until just before collision
    while (!place_meeting(x - dx * 0.25, y - dy * 0.25, tilemap)) {
        x -= dx * 0.25;
        y -= dy * 0.25;
    }

    // Calculate a small forward offset into the wall
    var impact_offset = 4; // tweak this for deeper or shallower placement
    var impact_x = x + lengthdir_x(impact_offset, direction);
    var impact_y = y + lengthdir_y(impact_offset, direction);

    // Spawn residue at the adjusted impact point
    var res = instance_create_depth(impact_x, impact_y, depth, oShadowBallResidue);
    res.image_angle = direction; // optional: match projectile rotation

    // Destroy the projectile immediately
    instance_destroy();
    exit;
}
