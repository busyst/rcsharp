   global main
main:
   push bp
   mov bp, sp
   sub sp, 16
   ;Array x access
   mov ax, WORD 0
   mov bx, bp
   add bx, 1
   sub bx, 8
   add bx, ax
   ;Array x index calculation
   mov ax, WORD 255
   mov BYTE [bx], al
   mov ax, WORD 4
   ;assign to variable 'q'
   mov WORD [bp - 10], ax
   mov ax, WORD 10
   ;assign to variable 'q'
   mov WORD [bp - 12], ax
   ;load value from struct q
   mov ax, WORD [bp - 10]
   mov dx, ax
   call print_num
   ;load value from struct q
   mov ax, WORD [bp - 12]
   mov dx, ax
   call print_num
   mov ax, WORD 4
   push ax
   ;load value from struct q
   mov ax, WORD [bp - 10]
   pop bx
   sub ax, bx
   mov bx, bp
   add bx, 1
   sub bx, 8
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   ;load value from struct q
   mov ax, WORD [bp - 10]
   mov dx, ax
   call print_num
   ;load value from struct q
   mov ax, WORD [bp - 12]
   mov dx, ax
   call print_num
   xor ax, ax
.exit_main:
   cli
   hlt
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
print_char:
   push bp
   mov bp, sp
   sub sp, 1
   mov BYTE [bp - 1], dl
   mov al, [bp - 1]
   mov ah, 0x0e
   int 0x10
   xor ax, ax
.exit_print_char:
   mov sp, bp
   pop bp
   ret
