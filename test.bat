@echo off
:: batch comment
cargo build
cargo run

if %errorlevel% neq 0 (
    echo Error: cargo run failed
    exit /b %errorlevel%
)
:: opt -O3 output.ll -o optimized_output.ll
llc -filetype=obj output.ll -o output.obj

if %errorlevel% neq 0 (
    echo Error: Failed to compile
    exit /b %errorlevel%
)
lld-link "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64\user32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64\kernel32.Lib" /subsystem:console /entry:main output.obj /out:output.exe
if %errorlevel% neq 0 (
    echo Error: Failed to link
    exit /b %errorlevel%
)
output.exe
echo %errorlevel%

del output.obj
del output.exe