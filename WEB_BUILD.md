# Bản thử HTML5

Trạng thái: **đã biên dịch và đóng gói HTML5 thành công** bằng runtime `2026.0.0.23`.

Bản thử: `output/web/20261102-223708-347/`. Gói upload: `output/web/MegamanZ-web-20261102-223708-347.zip`.

Đã sửa bụi dash lật và neo theo hướng di chuyển, bỏ bụi lướt của enemy, bổ sung bụi wall slide ở hai mặt tường (phát mỗi 10 step). Đã chạy thử dash trái/phải và trượt cả hai phía tường trên Edge với bản HTML5 mới, không ghi nhận lỗi runtime.

Đã nhập thêm 13 sheet effects/HUD từ Sprites INC thành 24 sprite (139 frame). Thanh máu X/Zero và boss dùng các phần HUD nguồn; dash, nhảy tường, va chạm và nổ đã dùng hiệu ứng mới. Icon vũ khí/menu và các hiệu ứng còn lại được giữ để dùng sau. Xem `art/effects/x4/README.md`. Đã compile và kiểm tra HUD, vòng đời hiệu ứng, cửa boss/chết/hồi sinh trên Edge.

Đã bổ sung thư viện X4 riêng gồm 33 prefab enemy/hazard và 34 sprite (218 frame), từ 44 sheet Sprites INC đã đối chiếu trùng lặp. Các prefab chưa được đặt vào màn hiện tại. Preview, nguồn và hướng dẫn nằm trong `art/enemies/x4/README.md`; đã compile và chạy từng prefab trên Edge, kiểm tra combat và vùng nghỉ/boss. AI là các hành vi nền tái sử dụng, chưa mô phỏng đầy đủ mọi pattern nguyên bản.

Đã bố trí lại encounter: Sky còn 13 enemy ở các đoạn chiến đấu; đầu màn, mọi checkpoint và lối ra phía trên được để trống. Intro không còn nhóm enemy ngay đầu màn, sát checkpoint hoặc trong arena chưa có boss. Jungle giữ các cụm enemy ngoài vùng nghỉ; hành lang và arena không có enemy thường hay bẫy tơ đặt sẵn. Vùng nghỉ được dựng lại sau mỗi lần vào màn/hồi sinh, ngăn enemy thường và đạn/bom của chúng đi vào. Boss và các object đòn đánh riêng của boss được phân biệt theo kế thừa; minion là enemy bổ sung nên bị loại khỏi arena. Kiểm tra GML thực tế trên Edge đã qua 10 điểm vào màn/checkpoint của Sky, Intro, Jungle và boss room; thử tạo thêm enemy/minion trong boss room cũng bị loại. Kiểm tra logic: `tools/test_stage_encounters.cjs`.

Đã cập nhật chuyển cảnh cửa boss: cuộn camera trong 60 frame khi nhân vật tự đi, dừng nhân vật 64 px bên trong arena, giữ trọn khung 320×240 trước WARNING. Camera reset cả khóa arena và chuyển cảnh khi hồi sinh/đổi player, và tự giải phóng khóa cũ khi player trở về hành lang. Edge headless đã kiểm tra vào cửa → arena → chết → hồi sinh tại `(4950, 2018)`, camera về `(4800, 1840)`, player nằm trong màn hình. Các kiểm tra hồi quy ở `tools/test_boss_camera.cjs` và `tools/test_boss_gate.cjs`.

Chạy `node tools/serve_web.cjs`, rồi mở `http://127.0.0.1:8080` để chơi bản build thành công mới nhất.

## Kết quả trên máy hiện tại

- Runtime tìm thấy: `2026.0.0.23` (GameMaker LTS 2026).
- Đã nhận licence đăng nhập IDE và module HTML5. Lỗi quyền `0000002A` ở lần thử đầu đã hết.
- CLI của runtime này cần `--pt` trỏ đến Project Tool đi kèm IDE. Script tự tìm qua IDE đang chạy; có thể truyền `-ProjectToolPath` khi IDE đóng hoặc cài ở thư mục riêng.
- Đã sửa schema HTML5 về phiên bản v0 và bổ sung các field bắt buộc, favicon/splash mặc định từ template GameMaker. Bản đầu chưa compile đã dùng nhầm tag v1.
- Dùng `--ac=--obfuscateCombine` cho bản thử để tránh lỗi compiler ở bước obfuscation. Bản xuất có JavaScript đọc được; không coi đây là bản release đã tối ưu dung lượng.
- Thư mục compiler tạm và thư mục đóng gói tách riêng để tránh Igor copy file lên chính nó.
- Các harness Node trong `tools/test_*.cjs` đều qua. Edge headless đã tải title, chọn X, bỏ qua cutscene/briefing, vào Sky, di chuyển/nhảy/đánh và Tab đổi sang Zero; ảnh trước/sau xác nhận nhân vật và camera thay đổi. Không có lỗi JavaScript/Console hoặc request thiếu file trong lượt thử cuối.
- Đã thử nút fullscreen, Shift+Tab thoát focus và phím gameplay không làm cuộn trang. Canvas giữ 320×240. Chưa kiểm tra toàn bộ boss/checkpoint, Firefox, hiệu năng dài hạn hoặc nghe âm thanh bằng người chơi.

## Thiết lập một lần

1. Mở GameMaker LTS 2026 và đăng nhập tài khoản của bạn trong IDE.
2. Trong Runtime Manager, cài module HTML5 cho runtime `2026.0.0.23`. Nếu dùng runtime khác, truyền đường dẫn đó vào script bên dưới.
3. Mở `MegamanZ/MegamanZ.yyp`, chọn target HTML5 và chạy thử trong IDE. Kiểm tra Output.

GameMaker yêu cầu đăng nhập IDE để build qua CLI: [Building & Testing via Command Line](https://manual.gamemaker.io/monthly/en/Settings/Building_via_Command_Line.htm).

## Build và đóng gói

Chạy từ thư mục gốc dự án:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/build_web.ps1 -CheckOnly
powershell -NoProfile -ExecutionPolicy Bypass -File tools/build_web.ps1
```

`ExecutionPolicy Bypass` chỉ áp dụng cho tiến trình PowerShell này, không thay đổi policy của hệ thống.

Nếu có nhiều tài khoản hoặc dùng runtime khác:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/build_web.ps1 -RuntimePath "C:\path\to\runtime" -UserPath "C:\path\to\username_number"
```

Script kiểm tra Igor, file licence và module HTML5 trước khi build. Compiler vẫn quyết định licence có hợp lệ hay không. Script không cài runtime hoặc đọc/in nội dung licence.

Mỗi lần build thành công tạo:

- `output/web/<thời gian>/index.html`: trang chơi, nút fullscreen và hướng dẫn.
- `output/web/<thời gian>/game/`: game HTML5 do GameMaker tạo.
- `output/web/MegamanZ-web-<thời gian>.zip`: trang chơi và game, không chứa log compiler.

Script in lệnh `node tools/serve_web.cjs ...` để mở qua `http://127.0.0.1:8080`, chỉ lắng nghe trên máy cục bộ. Có thể dùng máy chủ static khác. Không mở trực tiếp bằng `file://`.

Để host trên website, giải nén ZIP và phục vụ toàn bộ nội dung từ cùng một origin. Giữ nguyên đường dẫn `game/index.html`. Nếu tự xuất từ IDE, đặt bản xuất vào thư mục `game/`, rồi chép `web/index.html` ra ngoài thư mục đó.

## Phần đã điều chỉnh

- HTML5: WebGL tự chọn, texture page 8192 như Windows để các bản đồ lớn không bị compiler thu nhỏ, tắt lọc pixel, xuất `index.html`. Bản thử nhắm trình duyệt desktop; cần đánh giá bộ nhớ GPU trước khi hỗ trợ điện thoại.
- Web/GX không gọi các thao tác resize/center cửa sổ desktop. Trang host giữ tỷ lệ 4:3 và cung cấp nút fullscreen theo thao tác nhấp chuột.
- Nhạc nền giữ yêu cầu mới nhất khi audio context bị khóa, thử lại khi có âm thanh; dừng nhạc cũng xóa yêu cầu chờ. Title giữ nhạc chờ khi bỏ qua intro.
- Web dùng Sound Asset đã đóng gói. Fallback stream trên desktop chỉ nhận OGG thay vì thử MP3 không đúng định dạng của `audio_create_stream()`.
- Trang host giữ Arrow/Space/Tab cho gameplay; Shift+Tab đưa focus ra nút bên ngoài. Điều khiển cảm ứng chưa được thêm.

Tham khảo: [HTML5 setup](https://gamemaker.io/en/help/articles/setting-up-for-html5), [fullscreen và yêu cầu callback trên HTML5](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Cameras_And_Display/The_Game_Window/window_set_fullscreen.htm), [định dạng stream](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_create_stream.htm).

## Kiểm tra khi đã build được

1. Chrome/Edge và Firefox: tải trang, nhấp game, nghe nhạc title; thử bỏ qua intro trước khi bật âm thanh.
2. Bắt đầu game, chọn X/Zero, vào màn và kiểm tra nhạc chuyển đúng, không phát chồng.
3. Di chuyển, nhảy/dash/tường/thang/platform, bắn/chém, nhận đòn, chết và hồi checkpoint.
4. Thử Tab đổi nhân vật, Space và phím mũi tên không cuộn trang; Shift+Tab rời game.
5. Đổi kích thước trang, bật/tắt fullscreen bằng nút ngoài game và Esc; kiểm tra hình 4:3, HUD và pixel rõ.
6. Đổi binding, tải lại trang cùng origin và kiểm tra thiết lập còn được giữ.
7. Vào boss gate, thử camera/khóa input và reset sau chết. Kiểm tra Console/Network của trình duyệt không có lỗi hoặc file thiếu.
