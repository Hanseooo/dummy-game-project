if (!is_invincible && other.current_state != ENEMY_STATE.dead) {
    player_take_damage(other);
    apply_knockback(other, other.attack_knockback);
}

