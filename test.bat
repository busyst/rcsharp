@echo off
:: Build and run Rust project
cargo build -q || (
    echo Error: cargo build failed
    exit /b %errorlevel%
)

cargo run -q || (
    echo Error: cargo run failed
    exit /b %errorlevel%
)

:: Compile LLVM IR to object file
llc -filetype=obj output.ll -o output.obj || (
    echo Error: Failed to compile LLVM IR
    exit /b %errorlevel%
)

:: Read libraries from include.txt if it exists
set Libs=
if exist ./.code_snippets/readyLibs/include.txt (
    for /f "usebackq delims=" %%x in ("./.code_snippets/readyLibs/include.txt") do set "Libs=%%x"
)
:: Link the object file
if not "%Libs%"=="" (
    echo libs included: %Libs%
    lld-link %Libs% /subsystem:console /entry:main output.obj /out:output.exe
) else (
    lld-link /subsystem:console /entry:main output.obj /out:output.exe
)

if %errorlevel% neq 0 (
    echo Error: Failed to link
    exit /b %errorlevel%
)

:: Run the executable and check for specific error
output.exe
set run_error=%errorlevel%
echo.
echo Exit code: %run_error%

if %run_error% equ -1073741819 ( echo "ERROR: Access violation (0xC0000005)" )
if %run_error% equ -1073740940 ( echo "ERROR: Heap corruption (0xC0000374)" )
if %run_error% equ -1073741571 ( echo "ERROR: Stack overflow (0xC00000FD)" )
if %run_error% equ -1073741676 ( echo "ERROR: Integer division by zero (0xC0000094)" )
if %run_error% equ -1073741795 ( echo "ERROR: Illegal instruction (0xC000001D)" )
if %run_error% equ -1073741515 ( echo "ERROR: DLL Not Found (0xC0000135)" )
:: Cleanup
echo.
if exist output.obj del output.obj
if exist output.exe del output.exe

exit /b %run_error%