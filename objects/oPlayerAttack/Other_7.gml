

if (oPlayer.current_state == PLAYER_STATE.ATTACK) {
    if (oPlayer.is_moving) oPlayer.current_state = PLAYER_STATE.MOVING
    else oPlayer.current_state = PLAYER_STATE.IDLE 
    }   
