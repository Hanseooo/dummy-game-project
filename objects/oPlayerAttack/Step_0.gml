x = oPlayer.x
y = oPlayer.y

var target = instance_place(x, y, oEnemyParent)

if (target != noone && !target.hit_registered) {
    target.hp -= damage;
    target.hit_registered = true;

    // Knockback setup
    var kb_dir = image_angle;
    var kb_strength = 1

    target.knockback_dir = kb_dir;
    target.knockback_force = kb_strength;

    target.stun_timer = 15;
}
