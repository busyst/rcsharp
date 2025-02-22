main:
   push bp
   mov bp, sp
   sub sp, 9
   call arythm
   call arythm1
   mov ax, WORD 2
   mov dx, ax
   call arythm2
   mov ax, WORD 3
   mov dx, ax
   call arythm3
   mov ax, WORD 127
   ;assign to variable 'x'
   mov BYTE [bp - 1], al
   mov ax, WORD 32767
   ;assign to variable 'y'
   mov WORD [bp - 3], ax
   movzx ax, BYTE [bp - 1]
   mov dx, ax
   call arythm3
   ;assign to variable 'z'
   mov WORD [bp - 5], ax
   mov ax, WORD [bp - 3]
   mov dx, ax
   call arythm5
   ;assign to variable 'w'
   mov WORD [bp - 7], ax
   movzx ax, BYTE [bp - 1]
   mov dx, ax
   call print_num
   mov ax, WORD [bp - 3]
   mov dx, ax
   call print_num
   mov ax, WORD [bp - 5]
   mov dx, ax
   call print_num
   mov ax, WORD [bp - 7]
   mov dx, ax
   call print_num
   xor ax, ax
.exit_main:
   cli
   hlt
arythm:
   push bp
   mov bp, sp
   sub sp, 0
   xor ax, ax
.exit_arythm:
   mov sp, bp
   pop bp
   ret
arythm1:
   push bp
   mov bp, sp
   sub sp, 0
   mov ax, WORD 137
   jmp .exit_arythm1
.exit_arythm1:
   mov sp, bp
   pop bp
   ret
arythm2:
   push bp
   mov bp, sp
   sub sp, 2
   mov WORD [bp - 2], dx
   xor ax, ax
.exit_arythm2:
   mov sp, bp
   pop bp
   ret
arythm3:
   push bp
   mov bp, sp
   sub sp, 2
   mov WORD [bp - 2], dx
   mov ax, WORD [bp - 0]
   jmp .exit_arythm3
.exit_arythm3:
   mov sp, bp
   pop bp
   ret
arythm4:
   push bp
   mov bp, sp
   sub sp, 1
   mov BYTE [bp - 1], dl
   xor ax, ax
.exit_arythm4:
   mov sp, bp
   pop bp
   ret
arythm5:
   push bp
   mov bp, sp
   sub sp, 1
   mov BYTE [bp - 1], dl
   movzx ax, BYTE [bp - 0]
   jmp .exit_arythm5
.exit_arythm5:
   mov sp, bp
   pop bp
   ret
print_num:
   push bp
   mov bp, sp
   sub sp, 1
   mov BYTE [bp - 1], dl
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
.exit_print_num:
   mov sp, bp
   pop bp
   ret
