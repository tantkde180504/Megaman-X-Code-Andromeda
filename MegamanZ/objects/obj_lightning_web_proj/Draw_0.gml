/// @desc Lightning Web Projectile Draw
if (!deployed) {
    // Rotating seed/web bullet (Row 12, Frame 4..7)
    var _f = 4 + (floor(anim_timer) % 4);
    draw_web_spider_part(12, _f, x, y, 1, false);
} else {
    // Octagon stationary web net (Row 12, Frame 4..9)
    var _f = 4 + (floor(anim_timer * 1.5) % 6);
    draw_web_spider_part(12, _f, x, y, 1, ((deploy_timer % 4) < 2));
}
