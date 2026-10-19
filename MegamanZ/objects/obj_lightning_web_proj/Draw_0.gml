/// @desc Lightning Web Projectile Draw (Matched to Animation Frames)
if (!deployed) {
    // 1. In-flight Phase: Pulsing electric seed/orb (Row 12, Frames 0..3)
    var _f = floor(anim_timer * 1.2) % 4; // 0, 1, 2, 3
    draw_web_spider_part(12, _f, x, y, 1, false, 1.0);
} else {
    // 2. Deployed Phase: Opening web net then electrified octagon web
    var _alpha = 1.0;
    if (deploy_timer < 20) {
        // Flickering / dissipating in final frames
        _alpha = (deploy_timer % 4 < 2) ? 0.35 : 1.0;
    }
    
    var _flash = (deploy_timer % 8 < 2);
    
    if (deploy_anim_timer < 6) {
        // Frame 4: Web expanding/opening outward
        draw_web_spider_part(12, 4, x, y, 1, _flash, _alpha);
    } else {
        // Frames 5..9: Crackling electrified octagon web
        var _f = 5 + (floor(anim_timer * 0.6) % 5); // 5, 6, 7, 8, 9
        draw_web_spider_part(12, _f, x, y, 1, _flash, _alpha);
    }
}
