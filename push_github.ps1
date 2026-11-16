[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "ĐẨY DỰ ÁN BIO LÊN GITHUB"

$git = "C:\Users\NHS\AppData\Local\Programs\Git\cmd\git.exe"
$gh = "C:\Users\NHS\AppData\Local\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin\gh.exe"
$repoDir = "C:\Users\NHS\Desktop\bio-page"
Set-Location $repoDir

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "              ĐẨY DỰ ÁN BIO LÊN GITHUB TỰ ĐỘNG" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Kiểm tra đăng nhập
Write-Host "[1/3] Kiểm tra đăng nhập GitHub..." -ForegroundColor Yellow
$null = & $gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "  * Ní chưa đăng nhập GitHub trên máy này." -ForegroundColor Magenta
    Write-Host "  * Đang mở trình duyệt để ní đăng nhập..." -ForegroundColor Magenta
    Write-Host "  * Ní chỉ cần bấm Authorize (Cho phép) trên web là xong!" -ForegroundColor Magenta
    Write-Host ""
    & $gh auth login --web --git-protocol https
} else {
    Write-Host "  -> Đã đăng nhập GitHub thành công!" -ForegroundColor Green
}

Write-Host ""
Write-Host "[2/3] Cập nhật các thay đổi mới nhất..." -ForegroundColor Yellow
& $git add .
$null = & $git commit -m "Cap nhat trang bio Nguyen Van Binh" 2>&1

Write-Host ""
Write-Host "[3/3] Đang đẩy lên GitHub của ní..." -ForegroundColor Yellow
$res = & $gh repo create bio-page --public --source=. --remote=origin --push 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  -> Đang đồng bộ lên nhánh main..." -ForegroundColor Cyan
    & $git push -u origin main
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "  🎉 XONG RỒI NÍ ƠI! Toàn bộ code đã nằm gọn trên GitHub!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
