main:
    li t0, 0                    -- 1st fibonacci number
    li t1, 1                    -- 2nd fibonacci number
    li s0, 8                    -- nth fibonacci number (terminating index)
    li s1, 1                    -- current index
fibonacci:
    add t2, t0, t1
    mv t0, t1
    mv t1, t2
    addi s1, s1, 1              -- increment current index
    beq s1, s0, fibonacci_end
    j fibonacci
fibonacci_end:
    mv a0, a1                   -- print resulting integer
    mv a1, s0
    system
main_end:
    j main_end