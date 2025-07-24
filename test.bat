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
echo Exit code: %run_error%

if %run_error% equ -1073741819 (
    echo Access violation error detected
)

:: Cleanup
if exist output.obj del output.obj
if exist output.exe del output.exe

exit /b %run_error%