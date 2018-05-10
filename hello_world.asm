; Only runs on Linux kernels under amd64 arch
global      _start                ; Define our exported entry point into the logic


section     .text                 ; Logic section

_start:
    mov     rax, 1                ; write() syscall. See /usr/share/gdb/syscalls/amd64-linux.xml.
    mov     rdi, 1                ; Put stdout (fd #1) as an arg in rdi (destination register).
    mov     rsi, msg              ; Set our source register to point to our message in .data section.
    mov     rdx, len              ; Length of bytes to dump.
    syscall                       ; Execute write() with rax, rdi, rsi, and rdx 

    mov     rax, 60               ; exit() syscall. See /usr/share/gdb/syscalls/amd64-linux.xml.
    xor     rdi, rdi              ; Zeroize our exit code. Xor is shorter/faster than mov here.
    syscall


section     .data                 ; Static data section

msg         db  'Hello, World!', 0xa    ; Our string terminated with a line-feed.
len         equ $ - msg                 ; Since our string is static, we know its length.
