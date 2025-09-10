// Camera resolution (base zoom)
base_width  = 320;   // match your game resolution
base_height = 180;

// Create and assign camera to Viewport 0
cam = camera_create_view(0, 0, base_width, base_height, 0, noone, -1, -1, -1, -1);
view_camera[0] = cam;

// Follow target
target = oPlayer; // or set later

// Shake variables
shake_time = 0;
shake_strength = 0;

// Smooth follow variables
follow_speed = 0.05; // 0.1 = smooth, 1 = instant snap
cam_x = 0;
cam_y = 0;

// Zoom variables
zoom_current = 1;     // current zoom factor
zoom_target  = 1;     // target zoom factor
zoom_speed   = 0.075;   // how quickly to ease toward target

