player_ref = instance_find(oPlayer, 0);


heal_effect_active = false;
heal_effect_frame  = 0;


// In oPlayerEffectsController Create Event
depth = oPlayer.depth - 1; // smaller depth value = drawn later = in front
