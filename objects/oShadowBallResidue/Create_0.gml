alarm[0] = 60 * 5


if (instance_exists(oPlayer)) {
    if (point_distance(x, y, oPlayer.x, oPlayer.y) <= 256) {
        audio_play_sound(snd_distant_explosion, 0, false);
    }
}
