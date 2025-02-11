
main:
   mov bp, sp
   sub sp, 16
   mov ax, 0
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   push bx
   mov ax, 0
   pop bx
   mov BYTE [bx], al
   mov ax, 1
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   push bx
   mov ax, 1
   pop bx
   mov BYTE [bx], al
   mov ax, 2
   mov BYTE [bp - 33], al ; VAR i
_Loop0:
   ; if statement
   mov ax, 32
   push ax
   movzx ax, BYTE [bp - 33] ; VAR i
   pop bx
   cmp ax, bx
   setge al
   movzx ax, al
   cmp ax, 1
   jne .L_E0
   jmp _Loop0_EXIT
.L_E0:
   ; end if statement
   movzx ax, BYTE [bp - 33] ; VAR i
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   push bx
   mov ax, 2
   push ax
   movzx ax, BYTE [bp - 33] ; VAR i
   pop bx
   sub ax, bx
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   push ax
   mov ax, 1
   push ax
   movzx ax, BYTE [bp - 33] ; VAR i
   pop bx
   sub ax, bx
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   pop bx
   add ax, bx
   pop bx
   mov BYTE [bx], al
   mov ax, 1
   push ax
   movzx ax, BYTE [bp - 33] ; VAR i
   pop bx
   add ax, bx
   mov BYTE [bp - 33], al ; VAR i
   jmp _Loop0
_Loop0_EXIT:
   mov ax, 0
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 1
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 2
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 3
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 4
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 5
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 6
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 7
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 8
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 9
   imul ax, 1
   mov bx, bp
   sub bx, 32
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
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

times 510 - ($ - $$) db 0
dw 0xAA55
