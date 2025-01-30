
main:
   sub sp, 16
   mov ax, 3
   mov dx, ax
   call factorial
   mov WORD [bp - 2], ax ; VAR x
   mov ax, WORD [bp - 2] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   xor ax, ax
   cli
   hlt

print_num:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; argument 1:n 
   ; if statement
   mov ax, 10
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   cmp ax, bx
   setl al
   movzx ax, al
   cmp ax, 1
   jne .L_E0
   mov ax, 48
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   add ax, bx
   mov WORD [bp - 4], ax ; VAR ch
   mov ax, WORD [bp - 4] ; VAR ch
   mov dx, ax ; load arg 0 to call print_char 
   call print_char 
   jmp .L_EE2
.L_E0:
   ; else statement
   ; if statement
   mov ax, 16
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   cmp ax, bx
   setl al
   movzx ax, al
   cmp ax, 1
   jne .L_E1
   mov ax, 65
   push ax
   mov ax, 10
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   sub ax, bx
   pop bx
   add ax, bx
   mov WORD [bp - 4], ax ; VAR ch
   mov ax, WORD [bp - 4] ; VAR ch
   mov dx, ax ; load arg 0 to call print_char 
   call print_char 
.L_E1:
   ; end if statement
.L_EE2:
   ; end if statement
   xor ax, ax
   _exit_print_num:
   mov sp, bp
   pop bp
   ret


print_char:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; argument 1:n 

        mov al, [bp - 2]
        mov ah, 0x0e
        int 0x10
       xor ax, ax
   _exit_print_char:
   mov sp, bp
   pop bp
   ret


factorial:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; argument 1:n 
   ; if statement
   mov ax, 0
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   cmp ax, bx
   sete al
   movzx ax, al
   cmp ax, 1
   jne .L_E3
   mov ax, 1
   jmp _exit_factorial
   jmp .L_EE4
.L_E3:
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
.L_EE4:
   ; end if statement
   _exit_factorial:
   mov sp, bp
   pop bp
   ret

times 510-($-$$) db 0 ; Pad the rest of the boot sector with zeros
dw 0xAA55             ; Boot signature 
