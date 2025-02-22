main:
   push bp
   mov bp, sp
   sub sp, 34
   ;Array x access
   mov ax, WORD 0
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   ;Array x index calculation
   mov ax, WORD 0
   mov BYTE [bx], al
   ;Array x access
   mov ax, WORD 1
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   ;Array x index calculation
   mov ax, WORD 1
   mov BYTE [bx], al
   mov ax, WORD 2
   ;assign to variable 'i'
   mov BYTE [bp - 33], al
.main.Loop0:
   ;if statement
   mov ax, WORD 32
   push ax
   movzx ax, BYTE [bp - 33]
   pop bx
   cmp ax, bx
   setge al
   movzx ax, al
   cmp ax,1
   jne .main.L_E0
   jmp .main.Loop0_EXIT
.main.L_E0:
   ;end if statement
   ;Array x access
   movzx ax, BYTE [bp - 33]
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   ;Array x index calculation
   mov ax, WORD 2
   push ax
   movzx ax, BYTE [bp - 33]
   pop bx
   sub ax, bx
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   push ax
   mov ax, WORD 1
   push ax
   movzx ax, BYTE [bp - 33]
   pop bx
   sub ax, bx
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   pop bx
   add ax, bx
   mov BYTE [bx], al
   mov ax, WORD 1
   push ax
   movzx ax, BYTE [bp - 33]
   pop bx
   add ax, bx
   ;assign to variable 'i'
   mov BYTE [bp - 33], al
   jmp .main.Loop0
.main.Loop0_EXIT:
   mov ax, WORD 0
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 1
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 2
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 3
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 4
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 5
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 6
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 7
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 8
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
   mov dx, ax
   call print_num
   mov ax, WORD 9
   mov bx, bp
   add bx, 1
   sub bx, 32
   add bx, ax
   movzx ax, BYTE [bx]
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
