# Cinder Jackal — mẫu ngoại hình và full sheet v1

Trạng thái: có mẫu thiết kế ba tư thế và full sheet hình ảnh; chưa chuẩn hóa atlas/animation để đưa thẳng vào game.

## Full sheet

File: `cinder-jackal-fullsheet-v1.png` — PNG 941 × 1672 px, 32-bit ARGB, nền trong suốt.

Tạo bằng công cụ imagegen tích hợp từ toàn bộ sheet Slash Beast và mẫu Cinder Jackal ba tư thế. Các lượt chỉnh lần lượt chuyển ngoại hình toàn sheet, chỉnh khoảng cách và bổ sung lề. Prompt theo thứ tự: `prompt-fullsheet-v1.txt`, `prompt-fullsheet-v2.txt`, `prompt-fullsheet-v3.txt`. Ảnh được chọn là kết quả lượt cuối.

Đã xem toàn ảnh: có các nhóm đứng/chờ, lao, tư thế trên không, chém và vệt chém lớn, xoay/lộn, giật lùi, hạ thấp người, bộ phận cơ thể rời, móng và hiệu ứng va chạm/đạn lửa. Đây là các nhóm nhận diện theo hình, chưa phải ánh xạ state hoặc timing được xác minh trong game gốc. Chưa đối chiếu tự động từng frame một-một.

Đã kiểm tra alpha ở toàn bộ bốn cạnh: 0 pixel không trong suốt, không còn nội dung chạm mép canvas. Nội bộ sheet vẫn có vệt sáng/hiệu ứng nằm gần nhau, cần làm sạch và tách riêng khi tạo atlas.

**Giới hạn sử dụng:** không phải bản thay thế trực tiếp sheet 736 × 1312 bằng cùng tọa độ cắt. Kích thước, vị trí và khoảng cách đã thay đổi; chưa có lưới đồng nhất, frame rectangles, origin, collision mask, timing hoặc kiểm tra chạy animation. Cần đồng bộ chi tiết móng/giáp và làm sạch pixel ở kích thước native trước khi dùng trong GameMaker. Chưa thêm resource mới vào `.yyp`.

## Mẫu ngoại hình và nguồn

Nguồn tham chiếu do người dùng cung cấp trong dự án:
`MegamanZ/sprites/x4_SlashBeast/8116fe38-5a16-4f1a-aaad-b2801c378273.png`

Metadata resource: 736 × 1312 px; một frame chứa cả sheet; origin (0, 0). Đã xem ảnh nguồn, gồm các tư thế đứng, lao, nhảy, chém và hiệu ứng. Chưa xác minh thứ tự/timing animation theo game gốc.

Định hướng: giữ tỷ lệ cơ thể và cấu trúc khớp làm nền; đổi đầu sư tử thành chó rừng tai dài, bỏ bờm, giáp than đen/đồng cháy, lò ngực cam và bộ tản nhiệt sau vai. Ba tư thế mẫu: đứng chờ, chuẩn bị lao và chém.

Phương pháp: công cụ imagegen tích hợp, ảnh nguồn dùng làm tham chiếu. Prompt đầy đủ ở `prompt-v1.txt`.

Kết quả: `cinder-jackal-concept-v1.png`, 2172 × 724 px, 32-bit ARGB. Đã xem đủ ba tư thế và kiểm tra alpha = 0 tại góc ảnh cùng khoảng trống giữa các tư thế. Đây là ảnh trình bày phóng lớn, không phải kích thước sprite native hay một lưới frame đã chuẩn hóa. Móng, chi tiết giáp và vệt chém cần đồng bộ lại khi vẽ animation; chưa chạy trong engine.

Ảnh gốc là sprite Slash Beast từ Mega Man X4 của Capcom, không phải asset nguyên gốc của dự án. Bản chỉnh sửa cần giữ thông tin nguồn này; chưa xác minh điều khoản phân phối.

Trước khi dùng trong GameMaker cần chốt ngoại hình, sửa pixel từng frame, tách animation, xác định origin/mask và timing, kiểm tra ở độ phân giải 320 × 240. Ảnh AI phóng lớn không tự bảo đảm đúng lưới pixel hoặc nhất quán animation.
