# READY và hội thoại đầu màn

Đối chiếu hình ảnh và nhịp chuyển động với video [Mega Man X4 (X) - Sky Lagoon: No Damage](https://www.youtube.com/watch?v=L1K3wYO3xRo), đoạn READY khoảng 88,5–90,8 giây và hội thoại X khoảng 146 giây.

## READY

`obj_ready_intro` đếm Step ở 60 FPS, dùng sprite `spr_ready_intro` hiện có. Mọi tọa độ được căn theo tâm GUI; GUI gốc 320×240.

- Frame 0–17: tia sáng ngang mở đầu.
- Frame 6–23: chữ xuất hiện và chớp sáng.
- Frame 14–41: bốn dải xanh tím từ trên/dưới khép vào phía sau chữ rồi mờ đi.
- Frame 24–125: giữ chữ và lặp ánh kim.
- Frame 126–137: hai bản chữ trượt sang hai bên; tia teleport bắt đầu đi vào.
- Frame 138: đặt `global.stage_ready = true` và tự hủy.

Create khai báo `ready_duration = 138`, `teleport_start_frame = 126`. `player_state_intro()` chờ mốc teleport trước khi chạy tia sáng hoặc phát SFX. Không có READY thì teleport chạy ngay, kể cả hồi sinh ở checkpoint.

Room Start của `oGame` tạo READY trong room chơi khi không phải checkpoint respawn. Các room menu return trước đoạn này. Không đặt thêm instance vào room.

`boss_warning_can_start()` chờ READY bị hủy và cờ stage sẵn sàng; WARNING không vẽ hoặc đếm thời gian khi READY còn chạy.

## Hội thoại X ở Sky

`obj_stage_briefing` chờ cả READY và teleport-in kết thúc. Chân dung X nằm phía trên giữa màn hình; hộp chữ xanh đậm viền bạc ở bên dưới. Hộp và chân dung mở trong 12 frame, đóng trong 10 frame. Font MEDIUM giữ chữ hoa/thường, nội dung được phân trang theo chiều rộng thực 240 pixel và hai dòng mỗi trang. Chữ hiện với tốc độ 30 ký tự/giây.

Enter hoặc phím nhảy đã gán: hiện hết chữ / trang tiếp theo. Escape: đóng và bỏ qua. Input và AI bị khóa cho tới khi hộp đóng xong. Bảo vệ X khỏi sát thương không dùng iframe gây nhấp nháy sprite. Các lock được khôi phục khi object bị hủy. Hội thoại không tạo lại khi checkpoint respawn.

## Kiểm tra

```powershell
node tools/test_ready_intro.cjs
node tools/test_stage_briefing.cjs
node tools/test_boss_warning.cjs
```

Các harness chạy phần GML tương thích JavaScript với engine I/O mô phỏng; chúng kiểm tra nhịp, thứ tự, trạng thái Draw và phân trang theo font thật. Chúng không thay thế compile và playtest GameMaker.
