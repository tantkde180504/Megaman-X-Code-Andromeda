# READY Stage Intro

`obj_ready_intro` gồm Create, Step và Draw GUI. Chạy ở game speed 60 FPS:
frame 0–15 mở bars/laser; 10–26 chữ phóng vào và flash; 27–84 giữ chữ,
lặp ánh kim 16 frame; 85–100 khép chữ. Frame 100 đặt
`global.stage_ready = true` rồi tự hủy. Timeline đếm Step, không dùng delta time.

Sprite được tra theo tên `spr_ready_intro`, fallback `ReadyIntro` (tên hiện có
trong dự án). Giữ sheet nguyên 641×362, một subimage, origin 0,0; code cắt
đúng năm vùng đã chỉ định. Không cần tách sprite hoặc đổi tên asset.

## Khởi tạo

Dự án đã khởi tạo tự động trong Room Start của `oGame/Other_4.gml`, sau khi
tạo player; các room menu return trước đoạn này. READY chạy cùng teleport-in
mỗi lần vào room chơi hoặc restart room. Không cần đặt thêm instance trong room.

Khi dùng object ở dự án khác, đặt vào Room Creation Code của room chơi hoặc
Room Start của controller sau khi tạo player. Chỉ chọn một nơi:

```gml
if (!instance_exists(obj_ready_intro)) {
    instance_create_layer(0, 0, "Instances", obj_ready_intro);
}
```

Object chỉ phát tín hiệu hoàn tất, không tự thay đổi `global.input_locked`.
Nếu controller chịu trách nhiệm khóa điều khiển đầu màn, dùng:

```gml
// Room Start, sau khi tạo player; chỉ dùng cho room chơi.
ready_intro_waiting = true;
global.input_locked = true;
instance_create_layer(0, 0, "Instances", obj_ready_intro);
```

```gml
// Step của cùng controller; chạy trước xử lý điều khiển gameplay.
if (variable_instance_exists(id, "ready_intro_waiting")) {
    if (ready_intro_waiting) {
        if (global.stage_ready) {
            ready_intro_waiting = false;
            global.input_locked = false;
        }
        exit;
    }
}
```

Ví dụ khóa trên dành cho khoảng đầu màn do controller sở hữu; không dùng
đồng thời với hội thoại/cổng boss đang sở hữu cùng cờ khóa. `oGame` hiện
spawn player ở state INTRO: READY có thể chạy cùng teleport-in. Muốn chạy
sau teleport-in, chỉ tạo overlay khi player thoát state INTRO, một lần mỗi room.
Khóa input không dừng AI/vật lý: cần đặt spawn an toàn hoặc gate gameplay
ở controller nếu muốn cả thế giới chờ READY.

## Scale và kiểm tra

`gui_scale` tự lấy hệ số nguyên theo GUI 320×240, tối thiểu 1. GUI hiện tại
480×270 dùng scale 1; GUI 640×480 dùng 2. Cửa sổ lớn nhưng GUI cố định đã
được engine phóng theo viewport, không cần nhân scale lần nữa. Để chỉnh tay:

```gml
var _ready = instance_create_layer(0, 0, "Instances", obj_ready_intro);
_ready.auto_gui_scale = false;
_ready.gui_scale = 2;
```

Scale cố định là số nguyên và texture filtering tắt khi vẽ. Các pha zoom/khép
chủ động dùng scale lẻ. Mọi frame flash căn theo tâm vùng cắt riêng; shadow
lệch 2 pixel nguồn theo X/Y. Draw luôn trả blend về bm_normal, alpha về 1
và phục hồi texture filtering.

Compile/run trong GameMaker: kiểm tra các mốc 0/10/18/20/26/27/40/84/85/99,
tín hiệu ở 100, tâm GUI 480×270 và 640×480, màu HUD sau khi overlay kết thúc,
điều khiển được trả lại và không tạo overlay lặp. Chưa đối chiếu trực tiếp
video hoặc xác nhận bằng runtime GameMaker trong phiên triển khai này.
