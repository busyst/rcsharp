
main:
   mov bp, sp
   sub sp, 16
   mov ax, 241
   mov WORD [bp - 3], ax ; VAR b
   mov ax, 123
   mov BYTE [bp - 5], al ; VAR b
   mov ax, 1
   mov WORD [bp - 0], ax ; VAR a
   mov ax, 255
   mov BYTE [bp - 2], al ; VAR a
   xor ax, ax
   cli
   hlt
times 510 - ($ - $$) db 0
dw 0xAA55
