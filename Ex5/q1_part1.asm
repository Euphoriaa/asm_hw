.model small
.stack 100h
.data
    key_one db "Key 1 $"
.code
START:
    mov ax, @data
    mov ds, ax
    
    ;mask dos interrupt
    in al, 21h
    or al, 02h
    out 21h, al

PollKeyboard:
    ;is key pressed?
    in al, 64h
    test al, 01h
    jz PollKeyboard
    ;is '1' released?
    in al, 60h
    cmp al, 82h
    je PRINT_KEY_ONE
    jmp PollKeyboard
PRINT_KEY_ONE:
    mov dx, offset key_one
    mov ah, 09h
    int 21h
    jmp PollKeyboard

end START