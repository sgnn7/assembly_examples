; Only runs on Linux kernels under amd64 arch
global      _start                ; Define our exported entry point into the logic


section     .text                 ; Logic section

to_string:
    ; Args:
    ; rax - Number to convert to string (zero-padded)
    ; XXX: Assumption is that the numbr is above 0
    ;
    ; Output:
    ; - output_buff with string equal to the decimal value (zero padded)

    ; Save non-volatile registers
    push   rbx
    push   rdi

    mov    rbx, 10                ; We're trying to find base-10 version of the number

    ; Initialize rdi to the end of the buffer
    mov    rdi, output_buff + output_buff_len - 1

    ; Put newline char at the end of buffer (0xa)
    mov    [rdi], byte 0xa
    dec    rdi

  _to_string_div_loop:
    xor    rdx, rdx               ; Zeroize upper half of dividend arg
    div    rbx                    ; Do the actual division

    add    dl, 30h                ; Convert raw int to ascii digit by adding 30h (48 dec) to it
    mov    [rdi], dl              ; Move this ascii digit to the output buffer index
    dec    rdi                    ; Decrement the buffer index

    cmp    rdi, output_buff       ; Check if buffer index to buffer start
    jge    _to_string_div_loop    ; Repeat the loop if the buffer index is >= buffer start

    ; Restore non-volatile registers
    pop rdi
    pop rbx

    ret                           ; Return to caller


print_num:
    ; Args:
    ; - rax: Length of message
    ; - rbx: Pointer to the data

    ; Save non-volatile registers
    push  rdi
    push  rsi

    call  to_string

    ; Move args to correct registers
    mov   rax, 1                  ; write() syscall. See /usr/share/gdb/syscalls/amd64-linux.xml.
    mov   rdi, 1                  ; Put stdout (fd #1) as an arg in rdi (destination register).
    mov   rsi, output_buff        ; rsi will allways be the output buffer
    mov   rdx, output_buff_len    ; rdx will always be our output bufer length

    syscall                       ; Execute write() with rax, rdi, rsi, and rdx params

    ; Restore non-volatile registers
    pop   rsi
    pop   rdi

    ret                           ; Return to caller

_start:
    ; Print out 1 as the start
    mov   rax, 1
    call  print_num

    ; Initialize rax to 1
    ; XXX: rax is volatile so we can't assume it's still 1
    mov   rax, 1
    xor   rbx, rbx                ; Zeroize rbx which holds our current index

    mov   rcx, loop_iterations    ; rcx will hold how many numbers to calculate

  _loop_fib:
    xadd  rax, rbx                ; Calculate next number and store the previous value in rbx

    ; Save the volatile registers
    push  rax
    push  rcx

    ; Print out the current number (rax arg)
    call  print_num

    ; Restore the volatile registers
    pop   rcx
    pop   rax

    ; Loop again if we have more numbers to calculate (rcx)
    loop  _loop_fib

    ; Exit cleanly
    mov   rax, 60                 ; exit() syscall. See /usr/share/gdb/syscalls/amd64-linux.xml.
    xor   rdi, rdi                ; Zeroize our exit code. Xor is shorter/faster than mov here.
    syscall


section     .bss                  ; Variables section

output_buff  resb  32             ; Reserve 32 bytes for output string


section     .data                 ; Static data section

output_buff_len    equ 32         ; We know our buffer is 32 bytes
loop_iterations    equ 20         ; Do 20 loop iterations (100 will overflow)
