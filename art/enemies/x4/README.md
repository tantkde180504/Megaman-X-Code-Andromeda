# Thư viện enemy X4

Đã kiểm kê 44 sheet từ [Sprites INC – X4 / Enemy](https://sprites-inc.com/sprite.php?local=X/X4/Enemy/), đối chiếu các enemy đang có và thêm **33 prefab enemy/hazard**, **34 sprite** và **218 frame**. Sprite thứ 34 là Rock Ledge, chỉ là tài nguyên môi trường, không được gán thành enemy.

## Xem và sử dụng

- Mở [library-preview.html](library-preview.html) để xem animation `idle`, `move`, `attack` và các pose bổ sung. Trang hoạt động trực tiếp từ file, không cần server.
- Mở lại `MegamanZ/MegamanZ.yyp` trong GameMaker. Resource Tree có nhóm **Objects → Enemies → X4 Library** và **Sprites → X4 Library**.
- Dùng các object tên `oEnemy_X4_...`; `oEnemy_X4Base` là lớp dùng chung, không phải một enemy cụ thể.
- Enemy đi bộ có origin tại chân; enemy bay có origin ở giữa thân. Đặt origin của enemy mặt đất ngay trên mặt sàn, enemy bay trong khoảng không trống.
- Các prefab kế thừa `oEnemyParent`: dùng chung nhận sát thương, iframe, flash, contact damage, hiệu ứng chết và rơi vật phẩm. Quy tắc đầu màn/checkpoint/arena không có enemy thường vẫn áp dụng; không dùng các vùng đó để thử spawn thư viện.

Ví dụ tạo một enemy bay trong vùng chiến đấu:

```gml
var _enemy = instance_create_layer(1600, 960, "Instances", oEnemy_X4_HoverGunner);
_enemy.hp = 8;
_enemy.max_hp = 8;
_enemy.detect_range = 240;
_enemy.fire_cooldown = 90;
```

Chưa đặt các prefab mới vào bất kỳ màn đang chơi nào. Các enemy cũ như Mettaur D2, Batton, Fly Gunner, Guardian, Spiky Mk-II và Knot Beret được giữ nguyên.

## Mức độ hoàn thiện

Đây là thư viện **sprite đã nhập và AI nền để dùng/tinh chỉnh**, không phải bản mô phỏng đầy đủ từng enemy của game gốc. Có tám nhóm hành vi: tuần tra, bắn có báo trước, bay quanh điểm gốc, nhảy, chuyển động vòng, lao tới, sinh Kunbien và vật thể rơi. Các object có riêng HP, tốc độ, animation và mask thân cố định.

Đạn hiện dùng `oEnemyBullet` của dự án. Chưa tái hiện đầy đủ tia laser dài, chuỗi thân bám địa hình của Obeel, tách bộ phận, đóng băng/element weakness và mọi pattern nguyên bản. UFO, Metal Hawk và các máy hạng nặng cần không gian phù hợp với kích thước sprite thật; không thu nhỏ sprite để ép vào màn 320×240.

Các tên như Spring Robot, Buoy, Surprise Drill Robot dùng mô tả/filename của nguồn; không coi đó là xác nhận tên chính thức. Các sheet trùng và biến thể được ghi trong `library.json` và `CATALOG.md`.

## File và quy trình

| File | Nội dung |
|---|---|
| `source/` | 44 sheet gốc giữ nguyên byte, gồm credit có sẵn trên sheet |
| `sources.json` | URL, kích thước và SHA-256 của từng nguồn |
| `library.json` | Chọn frame, origin bổ sung, nhóm AI và thông số cơ bản |
| `imported.json` | Danh sách resource đã đăng ký, clip, mask và vùng cắt thực tế |
| `CATALOG.md` | Danh mục prefab và nguồn tương ứng |
| `library-preview-*.png` | Contact sheet của các prefab |
| `frame-audit-*.png` | Toàn bộ frame để kiểm tra cắt nhầm pose/đạn/nhãn |
| `browser-check.json` | Kết quả kiểm tra trong GameMaker HTML5 / Edge |

Art gốc thuộc Mega Man X4 của Capcom; nguồn lưu trữ là Sprites INC. Trang nguồn không cung cấp một giấy phép tái sử dụng độc lập. Credit/ripper có sẵn được bảo toàn trong các sheet gốc; không ghi các ảnh này thành ảnh do dự án tự vẽ hoặc public domain.

Các script cần Python, Pillow và NumPy:

```powershell
py tools/acquire_x4_enemy_sources.py
py tools/import_x4_enemy_library.py          # Chỉ dựng preview
py tools/import_x4_enemy_library.py --write  # Ghi lại các resource do importer quản lý
py tools/validate_x4_enemy_art.py
node tools/test_x4_enemy_library.cjs
```

UUID của sprite/frame/layer được tạo ổn định. Importer từ chối ghi đè resource cùng tên không thuộc lần import trước. Chỉnh nguồn `library.json` rồi import lại; các file sprite, profile GML và Create của prefab là đầu ra được sinh lại. Bộ AI dùng chung được viết tay trong `scr_x4_enemy_runtime`.

## Kiểm tra

Đã compile bằng runtime GameMaker LTS `2026.0.0.23`. Đã chạy các prefab trong bản HTML5 trên Edge headless để kiểm tra animation, chuyển động, chuyển state, nhận đòn qua API combat hiện tại và bị loại khi spawn trong vùng dành cho checkpoint/boss. Kiểm tra art so sánh pixel opaque của từng frame với vùng cắt nguồn, bảo đảm không resample, mất pixel khi đặt lên canvas hoặc đổi màu; mask và alpha được kiểm tra riêng.

Các kiểm tra này chưa thay thế việc cân bằng độ khó hoặc thử toàn bộ trên các kiểu địa hình và trình duyệt khác nhau trước khi bố trí thành encounter chính thức.
