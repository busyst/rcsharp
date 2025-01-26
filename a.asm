
main:
   mov ax, 1
   mov WORD [bp - 2], ax ; VAR x
_Loop0:
   mov ax, WORD [bp - 2] ; VAR x
   push ax
   mov ax, 1
   pop bx
   add ax, bx
   mov [bp - 2], ax
   mov ax, WORD [bp - 2] ; VAR x
   push ax ; prep arg 0
   pop dx ; load arg 0 to call was_dead 
   call was_dead 
   ; if statement
   mov ax, WORD [bp - 2] ; VAR x
   push ax
   mov ax, 2
   pop bx
   cmp ax, bx
   sete al
   movzx ax, al
   cmp ax, 1
   jne .L_E0
   jmp _Loop0_EXIT
.L_E0:
   ; end if statement
   jmp _Loop0
_Loop0_EXIT:
   xor ax, ax

was_dead:
   push bp
   mov bp, sp
   mov WORD [bp - 2], dx ; argument 1:x 
   ; if statement
   mov ax, WORD [bp - 2] ; VAR x
   push ax
   mov ax, 2
   pop bx
   cmp ax, bx
   sete al
   movzx ax, al
   cmp ax, 1
   jne .L_E1
   mov ax, WORD [bp - 2] ; VAR x
   push ax
   mov ax, 2
   pop bx
   add ax, bx
   jmp _exit_was_dead
   jmp .L_EE2
.L_E1:
   ; else statement
   mov ax, WORD [bp - 2] ; VAR x
   push ax
   mov ax, 2
   pop bx
   sub ax, bx
   jmp _exit_was_dead
.L_EE2
   ; end if statement
   mov ax, WORD [bp - 2] ; VAR x
   jmp _exit_was_dead
   _exit_was_dead:
   mov sp, bp
   pop bp
   ret

