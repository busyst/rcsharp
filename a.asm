
main:
   mov bp, sp
   sub sp, 16
   mov ax, 128
   mov WORD [bp - 2], ax ; VAR q
   mov ax, 16
   mov WORD [bp - 12], ax ; VAR e
   mov ax, 0
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 1
   pop bx
   mov BYTE [bx], al
   mov ax, 1
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 2
   pop bx
   mov BYTE [bx], al
   mov ax, 2
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 3
   pop bx
   mov BYTE [bx], al
   mov ax, 3
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 4
   pop bx
   mov BYTE [bx], al
   mov ax, 4
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 5
   pop bx
   mov BYTE [bx], al
   mov ax, 5
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 6
   pop bx
   mov BYTE [bx], al
   mov ax, 6
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 7
   pop bx
   mov BYTE [bx], al
   mov ax, 7
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   push bx
   mov ax, 8
   pop bx
   mov BYTE [bx], al
   mov ax, 0
   mov WORD [bp - 14], ax ; VAR i
_Loop0:
   ; if statement
   mov ax, 8
   push ax
   mov ax, WORD [bp - 14] ; VAR i
   pop bx
   cmp ax, bx
   sete al
   movzx ax, al
   cmp ax, 1
   jne .L_E0
   jmp _Loop0_EXIT
.L_E0:
   ; end if statement
   mov ax, WORD [bp - 14] ; VAR i
   imul ax, 1
   mov bx, bp
   sub bx, 10
   add bx, ax
   mov ax, WORD [bx]
   movzx ax, BYTE [bx]
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 1
   push ax
   mov ax, WORD [bp - 14] ; VAR i
   pop bx
   add ax, bx
   mov WORD [bp - 14], ax ; VAR i
   jmp _Loop0
_Loop0_EXIT:
   mov ax, WORD [bp - 2] ; VAR q
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 12] ; VAR e
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   xor ax, ax
   cli
   hlt

factorial:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; VAR argument N0: n
   ; if statement
   mov ax, 1
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   cmp ax, bx
   setle al
   movzx ax, al
   cmp ax, 1
   jne .L_E1
   mov ax, 1
   jmp _exit_factorial
   jmp .L_EE2
.L_E1:
   ; else statement
   mov ax, 1
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   sub ax, bx
   mov dx, ax
   call factorial
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   imul ax, bx
   jmp _exit_factorial
.L_EE2:
   ; end if statement
   _exit_factorial:
   mov sp, bp
   pop bp
   ret


print_num_u16:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; VAR argument N0: n
   mov ax, 8
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   mov cx, bx
   shr ax, cl
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 2] ; VAR n
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, 10
   mov dx, ax ; load arg 0 to call print_char 
   call print_char 
   mov ax, 13
   mov dx, ax ; load arg 0 to call print_char 
   call print_char 
   xor ax, ax
   _exit_print_num_u16:
   mov sp, bp
   pop bp
   ret


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
