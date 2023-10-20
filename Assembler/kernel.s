    li t0, 1
    beq a0, t0, read_int                # if a0 is 1, read integer
    li t0, 2
    beq a0, t0, print_int               # elsif a0 is 2, print integer
    li t0, 3
    beq a0, t0, read_char               # elsif a0 is 3, read character
    li t0, 4
    beq a0, t0, print_char              # elsif a0 is 4, print character
    li a0, -1
    ret                                 # return with error for invalid syscall encoding

read_int:
    j trap_handler

print_int:
    li t0, 65536
    sw a1, 0(t0)
    jr

read_char:
    j trap_handler

print_char:
    li t0, 65536
    sw a1, 0(t0)
    j exit_success

trap_handler:
    li t0, 65536
    lw t1, 0(t0)
trap_loop:
    lw t2, 0(t0)
    beq t1, t2, trap_loop
    mv a0, t2
    j exit_success;

exit_success:
    jr