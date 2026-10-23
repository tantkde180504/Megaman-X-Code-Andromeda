# Bố cục PS1 320×240

Camera, GUI và viewport dùng 320×240 trong cả sáu room. Cửa sổ 3× tương ứng
960×720; thay đổi kích thước hiển thị không thay đổi tọa độ giao diện hoặc map.
Game mặc định mở fullscreen theo màn hình hiện tại (Full HD nếu màn hình là
1920×1080), giữ tỷ lệ 4:3. Đã bỏ lớp sọc CRT/scanlines và viền tối giả lập CRT.
F3 chuyển về cửa sổ và đổi scale; F4 bật/tắt fullscreen.
Room Start của `oGame` đặt lại camera/viewport khi đổi room. Kích thước bản đồ
và vị trí instance môi trường không bị thay đổi.

- `oMenuManager/Draw_64.gml`: chọn nhân vật, hướng dẫn, credits và cutscene dùng
  tọa độ native. Hai card nhân vật chồng lên nhau ở cạnh chéo trong suốt,
  giữ nguyên pixel của sprite. Hai mugshot giữ kích thước 94×112.
- `oStageSelect`: nền lấy đủ 240 hàng nguồn, scroll tối đa 277; mô hình và
  monitor nằm trên panel nhiệm vụ. Animation tiến trong Step thay vì Draw.
- `scr_mmx_font`: `ps1_text_lines/pages` đo chữ bằng font bitmap thực tế.
  Cutscene dài chia trang, tiếp tục bằng Z/Enter; Skip vẫn giữ hành vi cũ.
- HUD dùng tên stage ngắn, chừa mép cho hai thanh HP; thoại boss xuống dòng
  trong panel. Thông báo OSD cũng xuống dòng để nằm trong chiều rộng 320.

Đã compile VM thành công bằng GameMaker runtime 2026.0.0.23 và kiểm tra metadata
của sáu room. Preview dùng asset thật, dựng bằng Python, không phải runner capture:
`artifacts/ps1_layouts/layout_contact_sheet.png`.
Script: `tools/preview_ps1_layouts.py`; có kiểm tra giới hạn panel/chữ trong preview.

Kiểm tra tương tác trong GameMaker: Title → chọn X/Zero → thoại dài nhiều trang
→ gameplay; Stage Select qua phím 9; vào boss để xem thoại/HP. Thử F3 đổi tỷ lệ
cửa sổ và F4 fullscreen. Chưa xác nhận các bước tương tác này trong runner.
