main:
   push bp
   mov bp, sp
   sub sp, 27
   mov ax, WORD 1
   ;assign to variable 'x'
   mov WORD [bp - 11], ax
   mov ax, WORD 2
   ;assign to variable 'x'
   mov WORD [bp - 13], ax
   mov ax, WORD 3
   ;assign to variable 'x'
   mov WORD [bp - 15], ax
   mov ax, WORD 4
   ;assign to variable 'x'
   mov WORD [bp - 17], ax
   mov ax, WORD 5
   ;assign to variable 'x'
   mov BYTE [bp - 18], al
   mov ax, WORD 1
   ;assign to variable 'y'
   mov WORD [bp - 2], ax
   mov ax, WORD 2
   ;assign to variable 'y'
   mov WORD [bp - 4], ax
   mov ax, WORD 3
   ;assign to variable 'y'
   mov WORD [bp - 6], ax
   mov ax, WORD 4
   ;assign to variable 'y'
   mov WORD [bp - 8], ax
   mov ax, WORD 5
   ;assign to variable 'y'
   mov BYTE [bp - 9], al
   ;load value from struct y
   movzx ax, BYTE [bp - 9]
   push ax
   ;load value from struct x
   movzx ax, BYTE [bp - 18]
   pop bx
   add ax, bx
   ;assign to variable 'x'
   mov BYTE [bp - 18], al
   xor ax, ax
.exit_main:
   cli
   hlt
