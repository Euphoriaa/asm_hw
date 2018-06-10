
;This is better cuz we don't have GARBAGE from time to time in our time stamps
.model small
.stack 100h
.data
    Old_int_off dw 0
    Old_int_seg dw 0   
    mins dw 0
    secs dw 0
    msecs dw 0
    ;* Results of set_results procedure
    ;* These will contain printable chars of mins, secs and msecs
    results db "0000$"

    is_visible db 1
    secs_elapsed_visible db 0
    ;NOTE: 34 = ascii for double quotes char
    quote db 34, "Computers are good at following instructions, but not at reading your mind.", 34, 0Ah, 0Dh
          db "- Donald Knuth$"
    empty db "                                                                                                        ", 0Ah, 0Dh
          db "                                                                                                       $"
.code
START:
    mov ax, @data
    mov ds, ax

    ;Save old int
    mov al, 08h
    mov ah, 35h
    int 21h
    mov Old_int_seg, es
    mov Old_int_off, bx

    push cs
    pop ds

    cli
    ;set new int
    mov al, 08h
    mov dx, offset MY_CLOCK_INT 
    mov ah, 25h
    int 21h
    sti

    mov ax, @data
    mov ds, ax   
    mov di, offset quote 
    call PRINT_DI
    MAIN:
        cmp msecs, 1000d
        jb PRINT_TIMER
            inc secs
            ;if is visible, increase time elapsed visible and check if 10 seconds have passed
            ;else, 1 second has passed, display message
            test is_visible, 1
            jz print_quote
                inc secs_elapsed_visible
                cmp secs_elapsed_visible, 10d
                jge DELETE_MESSAGE
                jmp CONT1
                DELETE_MESSAGE:
                    mov di, offset empty
                    call PRINT_DI
                    mov is_visible, 0d
                    mov secs_elapsed_visible, 0d
                jmp CONT1
            print_quote:
                mov is_visible, 1d
                mov di, offset quote
                call PRINT_DI
        CONT1:
            sub msecs, 1000d
            cmp secs, 60d
            jb PRINT_TIMER
                inc mins
                sub secs, 60d
        PRINT_TIMER:
            ;set cursor to middle of screen
            mov ah, 2
            mov bh, 0
            mov dh, 12
            mov dl, 40
            int 10h
            ;* update timer
            ;update mins
            mov ax, mins
            call set_results
            ;print mins
            mov dx, offset results
            mov ah, 09h
            int 21h
            mov dl, ":"
            mov ah, 2h
            int 21h
            ;update secs
            mov ax, secs
            call set_results
            ;print seconds
            mov dx, offset results
            mov ah, 09h
            int 21h
            mov dl, ":"
            mov ah, 2h
            int 21h
            ;update miliseconds
            mov ax, msecs
            call set_results
            ;print miliseconds
            mov dx, offset results
            mov ah, 09h
            int 21h
        jmp MAIN
PRINT_DI:
    mov ah, 2
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    mov dx, di
    mov ah, 09h
    int 21h
    ret

set_results PROC NEAR
    push ax
    push bx
    push cx
    push dx
    push si
    mov cx, 4d
    mov bx, 10d
    UPDATE_RESULTS:
        mov dx, 0d
        div bx
        ;dx = ax / 10 % 10 
        add dx, 30h
        mov si, cx
        mov results[si - 1], dl
        loop UPDATE_RESULTS
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
set_results ENDP

MY_CLOCK_INT:
    pushf
    call dword ptr [Old_int_off]
    ;* According to documnetation, the clock updates 18.2 times per second
    ;* hafle va fele, 1/18.2 = 0.055 +- eps
    ;* MEANING: every time this int is called, 55ms have passed,
    add msecs, 55d
    
    iret
end START