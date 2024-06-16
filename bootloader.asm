BITS 16                 ; Set the assembler to 16-bit mode
org 0x7C00              ; Set the origin address to 0x7C00

start:
    jmp main            ; Jump to the main code

print_string:
    mov ah, 0x0E        ; Set AH register to 0x0E, indicating the "print character" BIOS function
.repeat:
    lodsb               ; Load a byte from the memory location addressed by SI into AL, and increment SI
    test al, al         ; Test if the byte loaded into AL is zero (end of string)
    jz .done            ; If AL is zero, jump to the "done" label
    int 0x10            ; Call BIOS interrupt 0x10 to print the character in AL
    jmp .repeat         ; Jump back to the beginning of the loop to print the next character
.done:
    ret                 ; Return from the subroutine

main:
    mov si, hello_msg   ; Load the address of the bootloader message into SI register
    call print_string   ; Call the print_string subroutine to print the bootloader message

    mov ah, 0x02        ; Set AH register to 0x02, indicating the "read disk sectors" BIOS function
    mov al, 1           ; Number of sectors to read
    mov ch, 0           ; Cylinder number
    mov cl, 2           ; Sector number
    mov dh, 0           ; Head number
    mov dl, 0x80        ; Drive number (0x80 for first hard drive)
    mov bx, 0x8000      ; Load address in memory where the kernel will be loaded
    int 0x13            ; Call BIOS interrupt 0x13 to read disk sectors
    jc disk_error       ; If carry flag set (error), jump to disk_error

    jmp 0x8000          ; Jump to the memory address where the kernel is loaded

disk_error:
    mov si, disk_error_msg     ; Load the address of the disk error message into SI register
    call print_string          ; Call the print_string subroutine to print the disk error message
    jmp $                      ; Infinite loop (halt)

hello_msg: db 'Bootloader loaded. ', 0   ; Define the bootloader message string
disk_error_msg: db 'Error reading disk sector!', 0    ; Define the disk error message string

times 510-($-$$) db 0   ; Fill the rest of the boot sector with zeros
dw 0xAA55               ; The standard PC boot signature
