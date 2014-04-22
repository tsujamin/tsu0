tsu0
====

a mu0 implementation in verilog rtl

compilation
===========

compile both verilog sources with iverilog

```bash
cd rtl
iverilog control_unit.v ram.v
```

testing
=======

run the compiled binary with vvp

```bash
cd rtl
vvp a.out
gtkwave control_unit.vcd
```

programming
===========

the control unit loads its memory from data/ram.txt. 

this file consist of 256 instructions, each of 4 hexidecimal digits (one instruction 3 address).
memory is shared between instructions and data.

the bundled program counts backwards from 10 before storing 10 in the accumulator and halting.

instruction list
----------------

 * 0: ACC := [S]
 * 1: [S] := ACC
 * 2: ACC:= ACC + [S]
 * 3: ACC := ACC - [S]
 * 4: PC := S
 * 5: PC := S if ACC >=0
 * 6: PC :=S if ACC != 0
 * 7: HALT


