x = oPlayer.x
y = oPlayer.y

var target = instance_place(x, y, oEnemyParent)

if (target != noone && !target.hit_registered && target.current_state != ENEMY_STATE.dead) {
    target.hp -= damage;
    target.hit_registered = true;

    
    var kb_dir = image_angle;
    var kb_strength = 1

    target.knockback_dir = kb_dir;
    target.knockback_force = kb_strength;

    target.stun_timer = 15;
    
    if (owner.stamina <= owner.max_stamina) owner.stamina += 1
}
