@echo off
chcp 65001 >nul
cd /d "%~dp0"
title ĐẨY TOÀN BỘ CODE LÊN GITHUB
echo ================================================================
echo               ĐẨY DỰ ÁN BIO LÊN GITHUB TỰ ĐỘNG
echo ================================================================
echo.

set PATH=%LOCALAPPDATA%\Programs\Git\cmd;%LOCALAPPDATA%\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin;%PATH%

echo [1/3] Kiểm tra tài khoản GitHub...
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  * Ní chưa đăng nhập GitHub trên máy.
    echo  * Trình duyệt sẽ mở ra trang web GitHub ngay bây giờ.
    echo  * Ní chỉ cần bấm Authorize (Cho phép) là xong!
    echo.
    call gh auth login -w -p https
)

echo.
echo [2/3] Đang cập nhật commit mới nhất...
git add .
git commit -m "Cap nhat trang bio Nguyen Van Binh" >nul 2>&1

echo.
echo [3/3] Đang tạo và đẩy lên GitHub của ní...
call gh repo create bio-page --public --source=. --remote=origin --push
if %errorlevel% neq 0 (
    echo.
    echo Đang đồng bộ lên nhánh main...
    call git push -u origin main
)

echo.
echo ================================================================
echo  🎉 XONG RỒI NÍ ƠI! Toàn bộ code đã được đẩy lên GitHub thành công!
echo ================================================================
echo.
pause
