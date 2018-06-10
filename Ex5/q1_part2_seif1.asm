.model small
.stack 100h
.data
    last_time_stamp db 0
    current_time_stamp db 0
.code
START:
    mov ax, @data
    mov ds, ax
PollClock:
    ;poll seconds
    mov al, 00h
    out 70h, al
    in al, 71h
    mov current_time_stamp, al
    sub al, last_time_stamp
    jl check_abs_less_than_fiftyfive
    cmp al, 05h
    jge PRINT_STAR
    jmp PollClock
check_abs_less_than_fiftyfive:
    ;If al < last_time_stamp we had a wrap around
    cmp al, -55h
    jge PRINT_STAR
    jmp PollClock
PRINT_STAR:
    mov bl, current_time_stamp
    mov last_time_stamp, bl
    mov dl, "*"
    mov ah, 02h
    int 21h
    jmp PollClock

end START