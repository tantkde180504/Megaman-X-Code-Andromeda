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

Object `obj_title_intro` được tạo tự động bởi `oMenuManager` khi vào `rTitle`:
- **Tỷ lệ hiển thị**: Chuẩn pixel art 320×240 (tự động căn giữa màn hình và letterbox đen khi phóng to trên bất kỳ độ phân giải GUI nào).
- **Giai đoạn hiệu ứng Intro (60 FPS)**:
  1. `BEAM`: tia sáng và chữ MEGAMAN xuất hiện trong 30 frame đầu.
  2. `TEXT`: giữ chữ xanh trong lúc track intro `snd_bgm_title` phát một lần.
  3. `IMPACT`: bóng logo thu từ 3.5x về 1x từ giây 6,7 của nhạc Title.
  4. `LOGO`: logo hoàn chỉnh hiện khi nhạc Title đến giây 7, kèm flash và
     một vòng sáng viền 0 -> 10 -> 0. Nhạc tiếp tục phát khi vào menu.
  5. `BACKGROUND`: tăng alpha nền trong 25 frame, sau 35 frame ghép logo.
  6. `MENU`: giữ logo tĩnh và hiện Press Start; Enter/Space/Start mở menu ba mục.
  Track bắt đầu ở Step đầu tiên sau Room Start để không bị lệnh dừng nhạc
  phòng trước cắt mất. Nếu âm thanh không phát được thì dùng đồng hồ 60 FPS
  với cùng mốc 7 giây, tránh intro bị treo.
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

## 4. Logo đã làm sạch viền hồng

Đã xử lý phần màu magenta còn đục dính sát vùng trong suốt ở cả 11 frame,
cập nhật đồng thời PNG frame và PNG layer. Pixel ngoài vùng viền được giữ
nguyên; canvas 220×78 và origin (110,39) không đổi. RGB ẩn dưới alpha 0 cũng
được đưa về 0 để tránh lem màu khi lọc texture.

- Script: `tools/clean_title_logo_alpha.py`.
- Bản trước xử lý: `artifacts/title_logo_cleanup/before/`.
- Đối chiếu: `artifacts/title_logo_cleanup/logo_before_after.png`.
- ZIP mới để import lại: `artifacts/title_logo_cleanup/MMX_Andromeda_Sprites.zip`.
  Bản ZIP ở `title_import` vẫn là bộ nguồn trước khi sửa viền.
- Đã kiểm tra PNG layer, số frame/origin và compile VM thành công; chưa chạy runner.
