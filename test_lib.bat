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
cargo run --manifest-path "%ROOT_DIR%Cargo.toml" -q -- -L --input "%INPUT_FILE%" || (
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

:: LINKING STEP: Changed to output a DLL
if not "%Libs%"=="" (
    echo libs included: %Libs%
    lld-link /dll %Libs% "%TARGET_DIR%output.obj" /out:"%TARGET_DIR%output.dll"
) else (
    lld-link /dll "%TARGET_DIR%output.obj" /out:"%TARGET_DIR%output.dll"
)

if %errorlevel% neq 0 (
    echo Error: Failed to link DLL
    exit /b %errorlevel%
)
cd /d "%TARGET_DIR%"

echo.
if exist output.dll (
    for %%I in (output.dll) do echo DLL size: %%~zI bytes
    echo Successfully compiled to output.dll
)

:: Cleanup intermediate object file
if exist output.obj del output.obj

:: (Optional) The linker also generates .exp and .lib files when creating a DLL 
:: with exported functions. You usually want to keep them, but if you want to 
:: delete them, uncomment the next two lines:
:: if exist output.exp del output.exp
:: if exist output.lib del output.lib

cd /d "%ROOT_DIR%"

exit /b 0