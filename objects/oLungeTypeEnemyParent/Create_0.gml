/// — Stats & Health  
hp              = 6;         // override in child if needed  
damage          = 1;  

/// — Hit & Flash  
hit_registered  = false;  
hit_applied     = false;  
hit_flash_timer = 0;  
hit_flash_duration = 10; 

 

/// — Stun & Knockback  
stun_timer      = 0;  
knockback_dir   = 0;  
knockback_force = 0;  
knockback_decay = 0.5;  

fade_duration   = game_speed * 2;  
fade_timer      = -1;  

/// — Tilemap for collision  
tilemap         = layer_tilemap_get_id("Tiles_Wall");  

/// — State machine  
state_counter   = 0;  
current_state   = ENEMY_STATE.idle;  

/// — Wandering / Chasing  
move_speed      = 0.8;  
enemy_direction = random_range(0,359);  
move_x          = lengthdir_x(move_speed, enemy_direction);  
move_y          = lengthdir_y(move_speed, enemy_direction);  

/// — Melee & Dash attack  
attack_cd       = 4;       // frames of cooldown (will be randomized)  
attack_timer    = 0;  
attack_knockback= 3;  

dash_distance       = 180;  
dash_speed          = 4.5;  
dash_friction       = 0.95;  
attack_pause_time   = 24;  

// Trackers for dash phases  
dash_phase          = 0;  
dash_pause_timer    = 0;  
dash_traveled       = 0;  
dash_dir_x          = 0;  
dash_dir_y          = 0;  
dash_speed_initial     = dash_speed;  
dash_friction_initial  = dash_friction;  

can_drop_item = true

/// — Default sprite scaling (child can override)  
image_xscale = 0.8;  
image_yscale = 0.8;