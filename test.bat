@echo off
cargo run
nasm -f bin -o output.bin ./main.asm
nasm -f bin -o bootloader.bin ./bootloader.asm
copy /b bootloader.bin+output.bin combined.raw
if %errorlevel% equ 0 (
    qemu-system-x86_64 -drive format=raw,file=combined.raw
)

del output.bin
del bootloader.bin
del combined.raw