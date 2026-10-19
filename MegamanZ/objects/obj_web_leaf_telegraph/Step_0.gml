/// @desc Web Leaf Telegraph Step (Sine-wave sway downwards)
timer++;
anim_timer += 0.15;
x = start_x + (sin(timer * 0.15) * 8);
y += 1.5;

if (y >= y_floor || place_meeting(x, y, oSolid)) {
    instance_destroy();
}
