@echo off
chcp 65001 >nul
cd /d "%~dp0"
title ĐẨY WEB BIO LÊN VERCEL (MIỄN PHÍ)
echo ================================================================
echo        HƯỚNG DẪN ĐẨY TRANG BIO LÊN VERCEL MIỄN PHÍ
echo ================================================================
echo.
echo  Đang kết nối Vercel...
echo.
echo  * LƯU Ý LẦN ĐẦU CHẠY:
echo    1. Vercel sẽ mở trình duyệt để ní đăng nhập (chọn Google hoặc GitHub).
echo    2. Sau khi báo đăng nhập thành công, quay lại bảng này.
echo    3. Khi Vercel hỏi: "Set up and deploy?" -> Ní cứ gõ Enter (Y).
echo    4. Các câu hỏi tên project, thư mục -> Cứ gõ Enter liên tục là xong!
echo.
echo ================================================================
echo.
call npx.cmd vercel --prod
echo.
echo ================================================================
echo  Xong! Ní copy link web vercel.app ở trên gửi cho khách hoặc dán lên Bio là chuẩn nét!
echo ================================================================
pause
