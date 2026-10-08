; ==========================================================
;  8086 Assembly Calculator  (for emu8086)
;  Takes two single-digit numbers and an operator (+ - * /)
;  and prints the result. Handles negative results and
;  division by zero. Repeats until the user quits.
; ==========================================================

.model small
.stack 100h

.data
    msg_title   db 0Dh,0Ah,'=== 8086 Assembly Calculator ===',0Dh,0Ah,'$'
    msg_num1    db 0Dh,0Ah,'Enter first number (0-9): $'
    msg_op      db 0Dh,0Ah,'Enter operator (+ - * /): $'
    msg_num2    db 0Dh,0Ah,'Enter second number (0-9): $'
    msg_result  db 0Dh,0Ah,'Result = $'
    msg_rem     db '  remainder = $'
    msg_divzero db 0Dh,0Ah,'Error: cannot divide by zero.$'
    msg_badnum  db 0Dh,0Ah,'Invalid input. Please enter a digit 0-9: $'
    msg_badop   db 0Dh,0Ah,'Invalid operator. Use + - * / : $'
    msg_again   db 0Dh,0Ah,0Dh,0Ah,'Calculate again? (y/n): $'
    msg_bye     db 0Dh,0Ah,'Goodbye!',0Dh,0Ah,'$'

    num1        dw ?
    num2        dw ?
    op          db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg_title
    call print_str

next_calc:
    ; ---- first number ----
    lea dx, msg_num1
    call print_str
    call read_digit
    mov num1, ax

    ; ---- operator ----
    lea dx, msg_op
    call print_str
    call read_operator
    mov op, al

    ; ---- second number ----
    lea dx, msg_num2
    call print_str
    call read_digit
    mov num2, ax

    ; ---- choose operation ----
    lea dx, msg_result
    call print_str

    cmp op, '+'
    je  do_add
    cmp op, '-'
    je  do_sub
    cmp op, '*'
    je  do_mul
    jmp do_div

do_add:
    mov ax, num1
    add ax, num2
    call print_signed
    jmp ask_again

do_sub:
    mov ax, num1
    sub ax, num2
    call print_signed
    jmp ask_again

do_mul:
    mov ax, num1
    mov bx, num2
    imul bx                 ; result in DX:AX (small, so AX is enough)
    call print_signed
    jmp ask_again

do_div:
    cmp num2, 0
    jne divide_ok
    lea dx, msg_divzero
    call print_str
    jmp ask_again

divide_ok:
    mov ax, num1
    xor dx, dx
    mov bx, num2
    div bx                  ; AX = quotient, DX = remainder
    push dx                 ; save remainder
    call print_signed       ; print quotient
    lea dx, msg_rem
    call print_str
    pop ax                  ; get remainder back
    call print_signed
    jmp ask_again

ask_again:
    lea dx, msg_again
    call print_str
    mov ah, 01h
    int 21h
    or  al, 20h             ; make lowercase
    cmp al, 'y'
    je  next_calc

    lea dx, msg_bye
    call print_str

    mov ah, 4Ch             ; exit to DOS
    int 21h
main endp

; ----------------------------------------------------------
; print_str : prints the '$'-terminated string at DS:DX
; ----------------------------------------------------------
print_str proc
    mov ah, 09h
    int 21h
    ret
print_str endp

; ----------------------------------------------------------
; read_digit : reads a key until it is 0-9, returns value in AX
; ----------------------------------------------------------
read_digit proc
read_again:
    mov ah, 01h
    int 21h
    cmp al, '0'
    jb  bad_digit
    cmp al, '9'
    ja  bad_digit
    sub al, '0'
    xor ah, ah
    ret
bad_digit:
    lea dx, msg_badnum
    call print_str
    jmp read_again
read_digit endp

; ----------------------------------------------------------
; read_operator : reads a key until it is + - * /, returns it in AL
; ----------------------------------------------------------
read_operator proc
op_again:
    mov ah, 01h
    int 21h
    cmp al, '+'
    je  op_ok
    cmp al, '-'
    je  op_ok
    cmp al, '*'
    je  op_ok
    cmp al, '/'
    je  op_ok
    lea dx, msg_badop
    call print_str
    jmp op_again
op_ok:
    ret
read_operator endp

; ----------------------------------------------------------
; print_signed : prints the signed 16-bit number in AX
; ----------------------------------------------------------
print_signed proc
    push ax
    push bx
    push cx
    push dx

    test ax, ax
    jns  positive
    push ax
    mov  dl, '-'
    mov  ah, 02h
    int  21h
    pop  ax
    neg  ax

positive:
    xor cx, cx              ; digit counter
    mov bx, 10
divide_loop:
    xor dx, dx
    div bx                  ; AX / 10 -> AX = quotient, DX = digit
    push dx
    inc cx
    test ax, ax
    jnz divide_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_signed endp

end main
