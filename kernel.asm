org 0x8000              ; Set the origin address to 0x8000

section .text
start:
    mov si, kernel_msg  ; Load the address of the kernel message into SI register
    call print_string   ; Call the print_string subroutine to print the message

    call keyboard_print_input ; Call the keyboard subroutine to take user keyboard input and print it to the screen
    
    jmp $               ; Jump to the current address, creating an infinite loop

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

keyboard_print_input:
    ; Read a character from the keyboard
    mov ah, 0x00        ; Function code for reading character
    int 0x16            ; BIOS interrupt to read character
    mov [key], al       ; Store the character in the key variable

    ; Print the character to the screen
    mov ah, 0x0E        ; Function code for teletype output
    mov al, [key]       ; Load the character to print from memory
    int 0x10            ; BIOS interrupt to print character

    ; Endless loop to keep the program running
    jmp keyboard_print_input

section .bss
    key resb 1          ; Reserve one byte to store the character read from keyboard

section .data
kernel_msg: db 'Hello from Kernel!', 0   ; Define the kernel message string

section .text
