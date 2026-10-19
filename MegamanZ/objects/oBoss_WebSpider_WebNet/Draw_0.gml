/// @desc Web Net Draw
var _flash_color = ((timer div 4) % 2 == 0) ? c_white : make_color_rgb(180, 240, 255);
draw_sprite_part_ext(WebSpider, 0, 310, 501, 93, 93, x - (46 * scale), y - (46 * scale), scale, scale, _flash_color, 0.9);
