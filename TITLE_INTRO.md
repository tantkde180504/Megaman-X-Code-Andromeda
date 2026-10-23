# MEGAMAN X ANDROMEDA: Title Screen & Intro Animation

## 1. Kết quả xử lý ảnh bằng Python

Đã import bộ PNG chuẩn bị sẵn từ `D:\Download\MMX_Andromeda_Sprites` vào dự án,
giữ nguyên pixel RGBA, không rescale hoặc cắt lại từ hai sheet. Các sheet tham khảo:
- **Ảnh 1** (`X4_TitleScreen`): Sheet gốc kích thước 900×788 px (chứa màn hình Title 320×240 ở góc trên trái, chữ MEGAMAN, PRESS START, và cụm 3 trạng thái menu).
- **Ảnh 2** (`X_Andromeda`): Sheet logo Andromeda kích thước 1341×1173 px; không dùng kích thước này để suy ra tỷ lệ của bộ PNG đã cung cấp.

### 5 bộ Sprite đã trích xuất (RGBA trong suốt):
| Tên File | Kích thước | Số Sub-images | Mô tả |
| :--- | :--- | :--- | :--- |
| `spr_title_bg.png` | 320 × 240 | 1 | Nền vũ trụ đen, Trái Đất, trạm không gian tím, ký hiệu TM góc phải và dòng bản quyền Capcom. Phần logo cũ ở nửa trên đã được tô đen sạch sẽ. |
| `spr_megaman_text.png` | 209 × 42 | 1 | Chữ "MEGAMAN" màu xanh kim loại, tách nền hoàn toàn trong suốt. |
| `spr_logo_andromeda_strip11.png` | 2420 × 78 | 11 (220×78 mỗi frame) | 11 frames của logo "MEGAMAN X ANDROMEDA"; đã import nguyên từng frame vào canvas 220×78, origin (110,39). |
| `spr_menu_press_start.png` | 144 × 12 | 1 | Dòng chữ "PRESS START or ENTER" tách nền trong suốt. |
| `spr_menu_options_strip3.png` | 261 × 42 | 3 (87×42 mỗi frame) | 3 trạng thái chọn menu: Frame 0 = GAME START sáng, Frame 1 = CONTINUE sáng, Frame 2 = OPTION sáng. |

Tất cả đã được đóng gói thành file ZIP:
- **`MMX_Andromeda_Sprites.zip`** (Kích thước: ~387 KB)
- Vị trí tải:
  - `D:\MZ4\MMX_Andromeda_Sprites.zip`
  - `d:\Download\MMX_Andromeda_Sprites.zip`

---

## 2. Mã nguồn GML (`obj_title_intro`)

Object `obj_title_intro` được tạo tự động bởi `oMenuManager` khi vào `rTitle`, với depth `-20000`:
- **Tỷ lệ hiển thị**: Chuẩn pixel art 320×240 (tự động căn giữa màn hình và letterbox đen khi phóng to trên bất kỳ độ phân giải GUI nào).
- **Giai đoạn hiệu ứng Intro (60 FPS)**:
  1. `BEAM` (0 - 60 frame): Tia sáng trắng dãn ngang thành chữ MEGAMAN (scale 3x -> 1x theo chiều ngang, 0.05x -> 1x theo chiều dọc).
  2. `TEXT` (60 - 210 frame): Màn hình chớp trắng, chữ MEGAMAN xuất hiện rõ nét.
  3. `IMPACT` (210 - 300 frame): Chữ X / bóng logo thu nhanh từ 4.5x về 1x theo hiệu ứng quán tính (ease out cubic).
  4. `LOGO` (300 - 420 frame): Chớp trắng màn hình, logo `spr_logo_andromeda` hiện lên và chạy hiệu ứng sáng viền 11 frames theo dạng ping-pong (0 -> 10 -> 0).
  5. `BACKGROUND` (420 - 570 frame): Nền vũ trụ `spr_title_bg` tăng alpha dần (fade in), phía sau logo.
  6. `MENU` (570+ frame): Hiện chữ `PRESS START or ENTER` nhấp nháy chu kỳ 0.5 giây. Bấm Enter/Space/Start sẽ chuyển sang cụm 3 menu `GAME START / CONTINUE / OPTION`.
- **Điều khiển & Tương tác**:
  - Hỗ trợ cả bàn phím (Enter, Space, W/S, Up/Down) và Gamepad (Start, A, D-Pad Up/Down).
  - Phím Enter/Space/Start trong lúc Intro đang chạy sẽ bỏ qua (Skip) ngay đến màn hình Press Start.
  - Phím Enter tại menu:
    - **GAME START**: Bàn giao trực tiếp sang `oMenuManager` để vào màn chọn nhân vật (`MENU_STATE.CHAR_SELECT`).
    - **CONTINUE**: Báo thông báo tạm thời.
    - **OPTION**: Báo thông báo tạm thời.

## 3. Kiểm tra import

- Đã đăng ký 5 sprite trong `MegamanZ.yyp`, gồm đúng 11 subimage logo và 3 subimage menu.
- Background origin (0,0); các sprite chữ/logo/menu dùng Middle Centre.
- Đã so sánh từng frame RGBA với PNG nguồn và kiểm tra các file layer của GameMaker.
- ZIP kiểm tra CRC đạt, chỉ có đúng 5 PNG: `artifacts/title_import/MMX_Andromeda_Sprites.zip`.
- Preview ghép thật trên nền đen: `artifacts/title_import/title_preview.png`.
- Script import: `tools/import_title_assets.py`; từ chối ghi đè sprite đã tồn tại.
- Compile VM thành công bằng runtime GameMaker `2026.0.0.23`, tốc độ game xác nhận 60 FPS.
- Artifact compile: `artifacts/title_build/MegamanZ.win`. Chưa chạy kiểm tra tương tác trong runner.
- Preview animation im lặng: `artifacts/title_import/title_intro_preview.gif`; dựng bằng Python theo timeline, không phải capture từ runner.
- Hủy màn chọn nhân vật quay lại menu Andromeda, không chạy lại intro. Press Start hiện ngay khi vào menu.
- Cần mở lại/reload dự án nếu IDE đang mở trước khi import; thử Enter/Space, Up/Down, Game Start và hủy chọn nhân vật.
