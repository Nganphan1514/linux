# 🧩 Dự án Bash – Quản lý người dùng & nhóm trong Linux

## 🧠 Giới thiệu
Dự án giúp **quản lý người dùng, nhóm, bảo mật và xuất dữ liệu** trên hệ thống Linux thông qua giao diện dòng lệnh thân thiện.

## ⚙️ Tính năng chính
- 👤 Tạo, xóa, đổi mật khẩu người dùng
- 👥 Quản lý nhóm, thêm người vào nhóm
- 🔐 Khóa / mở khóa tài khoản
- 📄 Xuất danh sách người dùng, nhóm, log hoạt động
- 🧾 Đọc và thực hiện yêu cầu từ file tự động (batch mode)
- 🧰 Ghi log và phân loại log theo mức độ (INFO / WARN / ERROR)

---

## 🚀 Cài đặt & sử dụng

### 1️⃣ Cài đặt môi trường
```bash
sudo chmod +x install.sh
sudo ./install.sh

### Bước 2: Chạy chương trình chính (menu đầy đủ)
sudo ./main.sh

### (Tùy chọn) Bước 4: Chạy ở chế độ tự động bằng file yêu cầu
sudo ./file_mode.sh + tên file
Ví dụ:

sudo ./file_mode.sh example_requests.txt

### Gỡ cài đặt làm sạch sau test
sudo ./uninstall.sh
