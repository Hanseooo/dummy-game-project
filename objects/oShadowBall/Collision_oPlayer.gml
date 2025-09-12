if (!other.is_invincible) {
    // Apply knockback and damage
    other.apply_knockback(id, 3.5);
    other.player_take_damage(id);

    // Offset the residue slightly forward in the projectile's direction
    var impact_offset = 32; // tweak for deeper or shallower placement
    var impact_x = x + lengthdir_x(impact_offset, direction);
    var impact_y = y + lengthdir_y(impact_offset, direction);

    // Spawn residue at adjusted impact point
    var res = instance_create_depth(impact_x, impact_y, depth, oShadowBallResidue);
    res.image_angle = direction; // match projectile rotation

    // Destroy the projectile immediately
    instance_destroy();
}