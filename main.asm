
main:
   mov bp, sp
   sub sp, 16
   mov ax, 1
   mov WORD [bp - 11], ax ; VAR x
   mov ax, 2
   mov WORD [bp - 13], ax ; VAR x
   mov ax, 3
   mov BYTE [bp - 14], al ; VAR x
   mov ax, 4
   mov WORD [bp - 16], ax ; VAR x
   mov ax, 5
   mov WORD [bp - 18], ax ; VAR x
   mov ax, WORD [bp - 11] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 13] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   movzx ax, BYTE [bp - 14] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 16] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 18] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   xor ax, ax
   cli
   hlt

print_num:
   push bp
   mov bp, sp
   sub sp, 16
   mov BYTE [bp - 1], dl ; VAR argument N0: n
   mov al, [bp - 1]
   shr al, 4
   add al, 48
   cmp al, 58
   jb I_L0
   add al, 7
   I_L0:
   mov ah, 0x0e
   int 0x10
   mov al, [bp - 1]
   and al, 0x0F
   add al, 48
   cmp al, 58
   jb I_L1
   add al, 7
   I_L1:
   mov ah, 0x0e
   int 0x10
   xor ax, ax
   _exit_print_num:
   mov sp, bp
   pop bp
   ret


print_char:
   push bp
   mov bp, sp
   sub sp, 16
   mov BYTE [bp - 1], dl ; VAR argument N0: n
   mov al, [bp - 1]
   mov ah, 0x0e
   int 0x10
   xor ax, ax
   _exit_print_char:
   mov sp, bp
   pop bp
   ret

times 510 - ($ - $$) db 0
dw 0xAA55
