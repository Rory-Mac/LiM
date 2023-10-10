test_4:
lui     sp, 0xfffff     # -> load [sp] = 0xfffff000
addi    sp, sp, -96     # -> add -96 to [sp] -> [sp] = 0xffffefa0
sb      sp, 2(ra)       # -> RAM[ra + 2] = sign-extended sp[7:0]
lh      a4, 2(ra)       # -> a4 = sign-extended RAM[ra + 2][31:0]
lui     t2, 0xfffff     # -> load [t2] = 0xfffff000
addi    t2, t2, -96     # -> [t2] = [t2] + (-96) = 0xffffefa0
li      gp, 4           # -> [gp] = 4
bne     a4, t2, fail
success:
j success
fail:
j fail