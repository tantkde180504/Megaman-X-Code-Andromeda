# X4 effects và HUD

Nguồn: [Sprites INC — X4 Effects](https://sprites-inc.com/sprite.php?local=/X/X4/Misc/GameObjects/Effects/). Đã lưu 13 sheet nguyên bản trong `source/`; URL, kích thước và SHA-256 nằm trong `sources.json`. Đây là artwork của game Capcom được lưu trữ trên Sprites INC; trang nguồn không cung cấp giấy phép sử dụng độc lập.

## Thư viện

- 24 sprite GameMaker, 139 frame. Xem [preview](library-preview.html), `prepared.json` và các ảnh `frame-audit-*.png` để đối chiếu frame với vùng cắt nguồn.
- Hiệu ứng: nổ, khói, bụi dash, bụi nhảy tường, tia va chạm, dash X/Zero, silhouette afterimage X/Zero và hover tham khảo.
- HUD: nắp/thân thanh máu, chân biểu tượng X/Zero và ba biến thể boss, ô năng lượng, số, khung/icon vũ khí, life counter và icon pause của X/Zero.
- Hai sheet meteor trùng SHA-256 với thư viện enemy, dùng lại `sX4_MeteorVertical` và `sX4_MeteorDiagonal`.
- Sheet hover có tên gốc `MMX6_XHoverEffect.gif`: chỉ lưu làm tham khảo, không tự gán là hiệu ứng X4 hoặc bật trong gameplay.

## Đã nối vào game

`scr_x4_hud` ghép thanh máu từ các phần nguồn ở tỉ lệ pixel gốc. Chỉ thân thanh được lặp; biểu tượng không bị kéo giãn. Player dùng tối đa 32 ô, mỗi ô tương ứng 1 HP; boss dùng 32 ô theo tỉ lệ HP hiện có. Giữ luồng WARNING, nạp máu boss, chớp khi trúng đòn và ẩn thanh khi chết.

`scr_x4_effects` và `oFX_X4Burst` phát hiệu ứng một lần, vẽ đủ frame cuối rồi tự hủy. Các object hit spark, dash dust và enemy explosion hiện có dùng sheet mới. Player phát dash X/Zero khi bắt đầu dash và bụi/tia sáng khi nhảy khỏi tường.

Bụi dash neo ở góc dưới bên phải của sheet nguồn và lật theo hướng player; flash dùng `dash_dir` đã chốt. Bụi trượt tường phát ngay khi bắt đầu trượt rồi mỗi 10 step, kích thước 50%, neo tại mặt tường theo collision mask; dừng khi rời tường/chạm đất. Bụi nhảy khỏi tường dùng cùng điểm neo với kích thước gốc. Enemy Spiky, Tentoroid và nhện con không phát bụi dash của player. Kiểm tra hướng/cadence: `node tools/test_player_movement_effects.cjs`; đã kiểm tra thao tác dash trái/phải và wall slide hai phía trên HTML5 thực tế.

Khói, silhouette, icon pause/vũ khí và life counter được chuẩn bị để dùng sau. Afterimage hiện tại vẫn lấy hình nhân vật đang chuyển động; chưa thay bằng silhouette cố định. Không thêm ammo hay menu vũ khí giả khi gameplay chưa có hệ thống tương ứng.

## Tái tạo và kiểm tra

```powershell
py tools/acquire_x4_effect_sources.py
py tools/import_x4_effect_library.py
py tools/import_x4_effect_library.py --write
node tools/test_x4_effects_hud.cjs
py tools/validate_x4_effect_art.py
```

Importer mặc định chỉ tạo preview/manifest; `--write` mới cập nhật resource GameMaker và `.yyp`. Cần Pillow và NumPy, giống importer enemy. `library.json` mô tả vùng cắt, thứ tự clip và cách ghép ô năng lượng từ palette nguồn; `imported.json` ghi resource do importer quản lý.

Đã compile HTML5 bằng GameMaker runtime 2026.0.0.23 và chạy trên Edge: HUD X/Zero, thanh nâng cấp 32 HP, các hiệu ứng nổ/nhảy tường/va chạm/dash, tự hủy sau animation; kiểm tra lại cửa boss → chết → hồi checkpoint. Kiểm tra pixel đối chiếu 139 frame với crop/palette nguồn và xác nhận hai meteor trùng dữ liệu. Các pattern hiệu ứng mới là tích hợp vào hành vi hiện có, chưa xác nhận tái tạo chính xác toàn bộ timing của X4.
