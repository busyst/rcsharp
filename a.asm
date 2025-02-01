
factorial:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; argument 1:n 
   mov WORD [bp - 4], dx ; argument 2:x 
   mov WORD [bp - 6], dx ; argument 3:y 
   ; if statement
   mov ax, 1
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   cmp ax, bx
   setle al
   movzx ax, al
   cmp ax, 1
   jne .L_E0
   mov ax, 1
   jmp _exit_factorial
   jmp .L_EE1
.L_E0:
   ; else statement
   ; if statement
   mov ax, 2
   push ax
   mov ax, WORD [bp - 4] ; VAR x
   pop bx
   cmp ax, bx
   sete al
   movzx ax, al
   cmp ax, 1
   jne .L_E1
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
.L_E1:
   ; end if statement
.L_EE1:
   ; end if statement
   _exit_factorial:
   mov sp, bp
   pop bp
   ret


main:
   sub sp, 16
   mov ax, 6
   mov dx, ax
   call factorial
   mov WORD [bp - 2], ax ; VAR x
   mov ax, 2
   mov [bp - 2], ax
   mov ax, 3
   push ax
   mov ax, WORD [bp - 2] ; VAR x
   pop bx
   add ax, bx
   mov [bp - 2], ax
   mov ax, WORD [bp - 2] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
_Loop0:
   mov ax, WORD [bp - 2] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   jmp _Loop0
_Loop0_EXIT:
   xor ax, ax
   cli
   hlt

print_num:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; argument 1:n 

        mov al, [bp - 2]
        shr al, 4
        add al, 48

        cmp al, 58
        jb I_L0
        add al, 7
        I_L0:
        mov ah, 0x0e
        int 0x10

        mov al, [bp - 2]
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
   mov WORD [bp - 2], dx ; argument 1:n 

        mov al, [bp - 2]
        mov ah, 0x0e
        int 0x10
       xor ax, ax
   _exit_print_char:
   mov sp, bp
   pop bp
   ret


sum:
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
   setle al
   movzx ax, al
   cmp ax, 1
   jne .L_E3
   mov ax, 0
   jmp _exit_sum
   jmp .L_EE4
.L_E3:
   ; else statement
   mov ax, 1
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   sub ax, bx
   mov dx, ax
   call sum
   push ax
   mov ax, WORD [bp - 2] ; VAR n
   pop bx
   add ax, bx
   jmp _exit_sum
.L_EE4:
   ; end if statement
   _exit_sum:
   mov sp, bp
   pop bp
   ret

times 510-($-$$) db 0 ; Pad the rest of the boot sector with zeros
dw 0xAA55             ; Boot signature 
