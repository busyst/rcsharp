[bits 16]
[org 0x7C00]

; Entry point
start:
    ; Setup segments and stack
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Print boot message
    mov si, msg_booting
    call print_string

    ; Reset disk system
    mov ah, 0x00
    int 0x13
    jc disk_error

    ; Load kernel from disk
    mov si, msg_loading
    call print_string

    ; Disk read parameters
    mov ah, 0x02                ; Read sectors
    mov al, 1                   ; Sectors to read
    mov ch, 0                   ; Cylinder
    mov cl, 2                   ; Sector (boot is sector 1)
    mov dh, 0                   ; Head
    mov dl, 0x80                ; Drive (0x80 = first HDD)
    mov bx, 0x7E00              ; Load kernel after bootloader
    int 0x13
    jc disk_error               ; Check error flag

    ; Jump to loaded kernel
    mov si, msg_jumping
    call print_string
    jmp 0x0000:0x7E00

disk_error:
    mov si, msg_error
    call print_string
    hlt

; Print null-terminated string
print_string:
    push ax
    mov ah, 0x0E                ; BIOS teletype
.loop:
    lodsb                       ; Load next character
    or al, al                   ; Check for null terminator
    jz .done
    int 0x10                    ; Print character
    jmp .loop
.done:
    pop ax
    ret

; Data section
msg_booting  db "Booting... ", 0
msg_loading  db "Loading kernel... ", 0
msg_jumping  db "Jumping to kernel.", 0x0D, 0x0A, 0
msg_error    db "Disk error.", 0x0D, 0x0A, 0

; Boot signature
times 510 - ($-$$) db 0
dw 0xAA55