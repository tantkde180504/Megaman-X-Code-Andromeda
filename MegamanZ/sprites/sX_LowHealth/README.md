# X low-health idle

Six tired standing poses extracted from the project's existing `sSheet_Goc`
(`d39637a4-0e02-4a7e-961d-6aa3225312b5.png`). No new artwork or palette changes.
Source columns (inclusive): 262–294, 302–334, 343–375, 383–415, 422–454, 460–492;
source rows: 1257–1302. Original source licensing remains applicable.

Canvas 56×52, origin (28, 50), shared foot baseline at y=50, transparent background.
Six frames at 6 fps (0.1 frame per Step at the project's 60 fps).
The existing player collision mask is independent of these drawn sprites.

Used by `oPlayerX` when grounded and idle at 1–4 HP, matching the HUD's red threshold.
Shooting, landing, dash recovery, hurt and other action animations take priority.
Healing above 4 HP restores normal idle automatically.

Regenerate with `tools/slice_x_low_health.ps1`; it only writes this sprite's resource
and frame images. The source and other player sprites are left intact.
Static image/resource checks do not replace a GameMaker compile and playtest.
