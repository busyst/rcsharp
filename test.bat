@echo off
cargo run
nasm -f bin -o output.bin ./a.asm
if %errorlevel% equ 0 (
    qemu-system-x86_64 output.bin
)