@echo off
setlocal enabledelayedexpansion

rem Tentukan lokasi penyimpanan Nginx
set "nginx_dir=C:\nginx"

rem Periksa apakah folder Nginx sudah ada
if exist "%nginx_dir%" (
    echo Menghentikan Nginx...
    "%nginx_dir%\nginx.exe" -s stop
    timeout /nobreak /t 5 >nul
    echo Menghapus folder Nginx...
    rmdir /s /q "%nginx_dir%"
)

rem Tentukan URL unduhan Nginx
set "nginx_url=https://nginx.org/download/nginx-1.21.3.zip"

rem Buat folder penyimpanan jika belum ada
if not exist "%nginx_dir%" (
    mkdir "%nginx_dir%"
)

rem Unduh Nginx
echo Mengunduh Nginx...
bitsadmin.exe /transfer "NginxDownload" %nginx_url% "%nginx_dir%\nginx.zip"
:wait
timeout /nobreak /t 1 >nul
bitsadmin.exe /list | find "NginxDownload" >nul
if errorlevel 1 goto download_complete
goto wait

:download_complete
echo Pengunduhan selesai.

rem Ekstrak file zip Nginx
echo Mengekstrak Nginx...
tar -xf "%nginx_dir%\nginx.zip" -C "%nginx_dir%"

rem Hapus file zip setelah diekstrak
del "%nginx_dir%\nginx.zip"

rem Jalankan Nginx
echo Menjalankan Nginx...
"%nginx_dir%\nginx.exe"

echo Nginx berhasil diunduh, diinstal, dan dijalankan di %nginx_dir%.
echo.
echo Untuk menghentikan Nginx, jalankan: %nginx_dir%\nginx.exe -s stop

endlocal
