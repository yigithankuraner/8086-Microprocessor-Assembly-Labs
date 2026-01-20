org 100h

start:
    lea dx, msg_prompt
    mov ah, 09h
    int 21h

    lea di, buffer
    
input_loop:
    mov ah, 08h
    int 21h
    
    cmp al, 0Dh
    je input_done
    
    cmp al, 'a'
    jb input_loop
    cmp al, 'z'
    ja input_loop
    
    mov dl, al
    mov ah, 02h
    int 21h
    
    stosb
    jmp input_loop

input_done:
    mov al, 0
    stosb
    
    lea si, buffer
    lea di, str_close
    mov cx, 5
    
check_close:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne not_close
    inc si
    inc di
    loop check_close
    
    mov al, [si]
    cmp al, 0
    je program_exit

not_close:
    lea dx, msg_arrow
    mov ah, 09h
    int 21h
    
    lea si, buffer
    mov bl, 0
    mov cx, 0
    
process_loop:
    mov al, [si]
    cmp al, 0
    je print_count
    
    cmp al, bl
    ja char_selected
    jmp next_char

char_selected:
    cmp cx, 0
    je print_first
    
    push ax
    lea dx, msg_comma
    mov ah, 09h
    int 21h
    pop ax

print_first:
    mov dl, al
    mov ah, 02h
    int 21h
    
    mov bl, al
    inc cx
    
next_char:
    inc si
    jmp process_loop

print_count:
    lea dx, msg_arrow
    mov ah, 09h
    int 21h
    
    mov ax, cx
    mov bl, 10
    div bl
    mov bx, ax
    
    cmp bl, 0
    je print_single_digit
    
    mov dl, bl
    add dl, 30h
    mov ah, 02h
    int 21h

print_single_digit:
    mov dl, bh
    add dl, 30h
    mov ah, 02h
    int 21h
    
    lea dx, msg_newline
    mov ah, 09h
    int 21h
    
    jmp start

program_exit:
    ret

msg_prompt db 'enter input: $'
msg_arrow db ' > $'
msg_comma db ', $'
msg_newline db 0Dh, 0Ah, '$'
str_close db 'close'
buffer db 100 dup(?)




