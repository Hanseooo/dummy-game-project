if (!is_invincible && other.current_state != ENEMY_STATE.dead && (other.current_state == ENEMY_STATE.attack || other.current_state == ENEMY_STATE.melee)) {
    player_take_damage(other);
    apply_knockback(other, other.attack_knockback);
}