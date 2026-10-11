# Mega Man X: Code Andromeda

Dự án tái hiện trải nghiệm huyền thoại **Mega Man X4** trên nền tảng GameMaker 2026 LTS với độ chính xác cao về cơ chế vật lý, đồ họa sprite 32-bit và hệ thống chiến đấu đặc trưng của hai nhân vật chính: **X** và **Zero**.

---

## 🎮 Tính Năng Trọng Tâm

### 1. Nhân Vật X (Mega Man X)
- **Hệ thống di chuyển:**
  - Đi bộ, chạy đà, nhảy, tiếp đất nhịp nhàng.
  - Lướt Dash phản lực trên mặt đất và Air Dash trên không.
  - Bám và trượt tường (Wall Slide), đạp tường bật nhảy (Wall Jump).
  - Leo thang thẳng đứng (Ladder Climb) và leo thoát qua đỉnh thang.
- **Hệ thống chiến đấu (X-Buster):**
  - Bắn đạn thường (Lemon Pellets), tụ năng lượng Charge Shot cấp 1 & cấp 2.
  - Tích hợp bắn trong mọi trạng thái: Đứng bắn, chạy bắn, nhảy bắn, trượt tường bắn, và bám thang bắn.

### 2. Nhân Vật Zero
- **Hệ thống kiếm pháp Z-Saber:**
  - Chuỗi combo 3 đòn liên hoàn (Triple Slash Combo) với vệt kiếm liềm ngọc bích sắc nét.
  - Nhảy chém trên không trung (`sZero_AirSlash`) với vệt liềm quét 180 độ.
  - Lướt chém và hạ đất chém (`sZero_DashSlash`) chuyển đổi mượt mà giữa không và sàn.
  - Bám tường, trượt tường (`sZero_WallSlide`) và đạp tường bật nhảy.
  - Kỹ thuật Saber Dash Cancel (SDC) tái hiện chuẩn xác cơ chế hủy hoạt ảnh đỉnh cao.
- **Tuyệt kỹ võ công (Special Techniques):**
  - **Ryuenjin (Long Diên Nhận):** Thăng thiên trảm nguyên tố Hỏa.
  - **Hyouretsuzan (Băng Liệt Trảm):** Phi đao bổ băng từ trên không trung.
  - **Kuuenzan (Không Viên Trảm):** Xoay tròn trảm trên không.
  - **Raijingeki (Lôi Thần Kích):** Đâm kiếm phóng điện chấn động.

---

## 🕹️ Điều Khiển (Default Controls)

| Phím / Nút | Thao tác |
| :--- | :--- |
| **Mũi tên / D-Pad** | Di chuyển (Trái / Phải / Lên / Xuống) |
| **Z** | Nhảy (Jump) / Bật tường (Wall Jump) |
| **X** | Tấn công (X-Buster / Z-Saber) |
| **C** | Lướt (Dash / Air Dash) |
| **A / S** | Tuyệt kỹ đặc biệt của Zero (Special Technique) |

---

## 🛠️ Công Nghệ & Khởi Chạy
- **Engine:** GameMaker 2026 LTS (Format 2.0).
- **Ngôn ngữ:** GameMaker Language (GML).
- **Mở dự án:** Mở file [`MegamanZ/MegamanZ.yyp`](MegamanZ/MegamanZ.yyp) bằng GameMaker Studio 2 / GameMaker LTS.
