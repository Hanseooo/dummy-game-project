/// oShadowBall Create
// (If you didn’t set them on spawn, you can default here)
    speed = 0.5;
    max_speed = random_range(1, 2)
    accel = 0.05
if (!variable_instance_exists(id, "range"))      range = 256;
if (!variable_instance_exists(id, "damage"))      damage = 2;

distance_trav = 0;
tilemap = tilemap
owner = noone


image_xscale = 0.8
image_yscale = 0.8

audio_play_sound(snd_abstract_magic_swoosh, 0, false)