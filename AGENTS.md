# Hướng dẫn làm việc

## Đọc dự án
- Dự án GameMaker/GML: mở `MegamanZ/MegamanZ.yyp`. Khảo sát manifest và code theo luồng liên quan; phân biệt điều xác nhận trong code với giả thuyết cần chạy thử.
- `README.md`, `CONTEXT.md` và `megaman_x4_gamemaker_plan.md` cung cấp bối cảnh khi cần hiểu mục tiêu. Roadmap và điều khiển trong tài liệu có phần cũ; đối chiếu implementation hiện tại.
- Mặc định bỏ qua `**/cache/`, `**/output/`, `**/Build/`, `.git/`, dữ liệu ảnh/âm thanh trong `MegamanZ/sprites/`, `sounds/`, `datafiles/`. Chỉ đọc metadata asset cụ thể khi cần kiểm tra mask/origin/tham chiếu; không liệt kê toàn bộ sprite.

## Các điểm vào quan trọng
- `MegamanZ/objects/`: mỗi object có `.yy` khai báo kế thừa/event và `.gml` chứa code. `scripts/` chứa hàm dùng chung; `rooms/` chứa bố trí instance. Nhóm Core/Player/Enemies trong Resource Tree là nhóm logic.
- `oGame` persistent: Create khởi tạo global/controller; Room Start (`Other_4.gml`) gọi `scr_build_*`, bổ sung instance và spawn player tại checkpoint. Đọc cả room `.yy` và builder khi sửa bố trí/spawn.
- Input: `oInput/Step_1.gml` (Begin Step) gọi `scr_input`, cập nhật `global.input` và buffer.
- Player: `oPlayer` → `oPlayerX`/`oPlayerZero`. Parent Step chạy `player_state_execute()` rồi `player_handle_movement_and_collision()`. Logic ở `scr_player_states`, `scr_player_physics`; thông số/enum ở `scr_constants`.
- Chiến đấu/animation: Step và Draw của X/Zero, `oBullet_*`, `oSaberHitbox`, `scr_combat`. Chết/hồi sinh: `scr_player_death`, `obj_x_death_effect`; checkpoint/cổng: `oTrigger_Checkpoint`, `oTrigger_BossGate`.
- Enemy: `oEnemyParent` và event của từng enemy; boss có `obj_boss_parent`. Có cả `oBoss_WebSpider` và `obj_boss_web_spider`; xác minh nơi spawn trước khi chọn implementation để sửa.
- Camera: `oCamera/Step_2.gml` (End Step), `scr_camera`; HUD: `oUI_HUD/Draw_64.gml` (Draw GUI). Camera/cổng/reset boss có tọa độ arena cố định cần đối chiếu khi sửa map.

## Quy ước GML
- Theo phong cách file đang sửa: hàm/biến `snake_case`, local thường có `_`, enum/macro viết hoa; giữ cách đặt tên resource hiện có (`o...` và `obj_...`).
- Giữ thứ tự `event_inherited()`: X gọi parent trước logic riêng; Zero tạm chặn input trước parent rồi khôi phục. Hàm state/vật lý dùng biến instance trực tiếp, cần đúng ngữ cảnh player.
- Dùng vật lý tự viết `hsp/vsp` và subpixel; phân biệt với `hspeed/vspeed` dùng ở một số đạn. Player dùng collision mask riêng; hình vẽ/animation được chọn thủ công trong Draw.
- Tái sử dụng `player_take_damage()`/`deal_damage_to_target()`; đọc xử lý shield, iframe và hitbox theo frame trước khi đổi damage.
- Nhiều controller lấy player đầu tiên qua `instance_find(oPlayer, 0)` và spawn trên layer `"Instances"`; kiểm tra các phụ thuộc này khi đổi vòng đời object.
- Các script PowerShell/Python ở gốc có thể sinh/ghi lại resource. Đọc script trước khi chạy; không coi tên `build_*` là lệnh kiểm tra an toàn.

## Kiểm tra thay đổi
- Xem `git diff --check` và diff để bảo đảm phạm vi thay đổi; khi thêm resource/event, đối chiếu `.yyp` và `.yy` tương ứng.
- Mở `.yyp` bằng GameMaker, compile/run và kiểm tra lỗi Output. Chưa xác nhận có bộ test tự động hoặc lệnh CLI kiểm thử chuẩn; ghi rõ nếu chưa chạy được engine.
- Chọn kiểm tra phù hợp phần sửa: `1` playground, `2` Intro, `3` Web Spider, `5` Nightmare Zero; `F1` xem state/vận tốc/ground/wall; `Tab` đổi X/Zero.
- Với player/combat: thử nhảy/dash/tường/thang/platform, bắn/chém, nhận đòn, chết và checkpoint theo phạm vi thay đổi. Với cổng/boss: thử khóa input, camera, vào arena và reset sau chết.
- Phím debug có chồng chéo: `B` được xử lý ở cả oGame và oPlayer; `K` vừa dash vừa spawn Web Spider. Đọc handler hiện tại trước khi dùng để tái hiện lỗi.
