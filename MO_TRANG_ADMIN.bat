@echo off
netstat -ano | findstr :3333 | findstr LISTENING >nul
if errorlevel 1 (
    echo Dang khoi dong Server Bio Studio...
    start /b python "%~dp0server.py"
    timeout /t 1 /nobreak >nul
)
start http://127.0.0.1:3333/admin.html
