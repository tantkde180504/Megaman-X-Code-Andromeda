/// @desc Web Projectile Draw
var _frame = floor(anim_timer) % 4;
var _src_x = 290;
if (_frame == 1) _src_x = 344;
else if (_frame == 2) _src_x = 405;
else if (_frame == 3) _src_x = 464;

draw_sprite_part_ext(WebSpider, 0, _src_x, 715, 43, 42, x - 21, y - 21, 1, 1, c_white, 1.0);
