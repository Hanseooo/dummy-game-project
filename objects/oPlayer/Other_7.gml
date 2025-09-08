

if (current_state == PLAYER_STATE.ATTACK) {
    current_state = is_moving ? PLAYER_STATE.MOVING : PLAYER_STATE.IDLE;
}