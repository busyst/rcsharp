@echo off
setlocal
set "ROOT_DIR=%~dp0"
set "TARGET_DIR=%~dp1"
set "INPUT_FILE=%~f1"

cargo build --manifest-path "%ROOT_DIR%Cargo.toml" -q || (
    echo Error: cargo build failed
    exit /b 1
)
cd /d "%TARGET_DIR%"
cargo run --manifest-path "%ROOT_DIR%Cargo.toml" -q -- "%INPUT_FILE%" || (
    echo Error: cargo run failed
    exit /b %errorlevel%
)

llvm-as -disable-output output.ll || (
    echo Error: LLVM IR Syntax/Type Error
    exit /b %errorlevel%
)

llc -filetype=obj output.ll -o output.obj || (
    echo Error: Failed to compile LLVM IR
    exit /b %errorlevel%
)
cd /d "%ROOT_DIR%"

set Libs=
if exist ".code_snippets\readyLibs\include.txt" (
    for /f "usebackq delims=" %%x in (".code_snippets\readyLibs\include.txt") do set "Libs=%%x"
)

if not "%Libs%"=="" (
    echo libs included: %Libs%
    lld-link %Libs% /subsystem:console /entry:main "%TARGET_DIR%output.obj" /out:"%TARGET_DIR%output.exe"
) else (
    lld-link /subsystem:console /entry:main "%TARGET_DIR%output.obj" /out:"%TARGET_DIR%output.exe"
)

if %errorlevel% neq 0 (
    echo Error: Failed to link
    exit /b %errorlevel%
)
cd /d "%TARGET_DIR%"

output.exe
set run_error=%errorlevel%
echo.
echo Exit code: %run_error%

if exist output.exe (
    for %%I in (output.exe) do echo Executable size: %%~zI bytes
)
if %run_error% equ -1073741819 ( echo "ERROR: Access violation (0xC0000005)" )
if %run_error% equ -1073740940 ( echo "ERROR: Heap corruption (0xC0000374)" )
if %run_error% equ -1073741571 ( echo "ERROR: Stack overflow (0xC00000FD)" )
if %run_error% equ -1073741676 ( echo "ERROR: Integer division by zero (0xC0000094)" )
if %run_error% equ -1073741795 ( echo "ERROR: Illegal instruction (0xC000001D)" )
if %run_error% equ -1073741515 ( echo "ERROR: DLL Not Found (0xC0000135)" )

echo.
if exist output.obj del output.obj
if exist output.exe del output.exe
cd /d "%ROOT_DIR%"

exit /b %run_error%