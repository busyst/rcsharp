
main:
   mov bp, sp
   sub sp, 16
   call arythm 
   call arythm1 
   mov ax, 2
   mov dx, ax ; load arg 0 to call arythm2 
   call arythm2 
   mov ax, 3
   mov dx, ax ; load arg 0 to call arythm3 
   call arythm3 
   mov ax, 127
   mov BYTE [bp - 1], al ; VAR x
   mov ax, 32767
   mov WORD [bp - 3], ax ; VAR y
   movzx ax, BYTE [bp - 1] ; VAR x
   mov dx, ax
   call arythm3
   mov WORD [bp - 5], ax ; VAR z
   mov ax, WORD [bp - 3] ; VAR y
   mov dx, ax
   call arythm5
   mov WORD [bp - 7], ax ; VAR w
   movzx ax, BYTE [bp - 1] ; VAR x
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 3] ; VAR y
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 5] ; VAR z
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   mov ax, WORD [bp - 7] ; VAR w
   mov dx, ax ; load arg 0 to call print_num 
   call print_num 
   xor ax, ax
   cli
   hlt

arythm:
   push bp
   mov bp, sp
   sub sp, 16
   xor ax, ax
   _exit_arythm:
   mov sp, bp
   pop bp
   ret


arythm1:
   push bp
   mov bp, sp
   sub sp, 16
   mov ax, 137
   jmp _exit_arythm1
   _exit_arythm1:
   mov sp, bp
   pop bp
   ret


arythm2:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; VAR argument N0: a
   xor ax, ax
   _exit_arythm2:
   mov sp, bp
   pop bp
   ret


arythm3:
   push bp
   mov bp, sp
   sub sp, 16
   mov WORD [bp - 2], dx ; VAR argument N0: a
   mov ax, WORD [bp - 0] ; VAR a
   jmp _exit_arythm3
   _exit_arythm3:
   mov sp, bp
   pop bp
   ret


arythm4:
   push bp
   mov bp, sp
   sub sp, 16
   mov BYTE [bp - 1], dl ; VAR argument N0: a
   xor ax, ax
   _exit_arythm4:
   mov sp, bp
   pop bp
   ret


arythm5:
   push bp
   mov bp, sp
   sub sp, 16
   mov BYTE [bp - 1], dl ; VAR argument N0: a
   movzx ax, BYTE [bp - 0] ; VAR a
   jmp _exit_arythm5
   _exit_arythm5:
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

times 510 - ($ - $$) db 0
dw 0xAA55
