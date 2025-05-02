@echo off
chcp 65001 >nul
:: 呼叫 PowerShell 腳本取得 ROC 日期
for /f %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -File getDate.ps1') do set rocdate=%%i

:: 設定檔名
set filename=本所謄本-%rocdate%.csv

:: 執行下載
curl "YourAPI/export.jsp?startDate=%rocdate%&endDate=%rocdate%" -o "%filename%"

echo 檔案已匯出
pause
