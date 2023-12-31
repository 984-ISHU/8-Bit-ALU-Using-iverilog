# 8-Bit-ALU-Using-iverilog

8-bit ALU performing 8 operations using iverilog.
This repo consists of the main file alu.v and its testbench tb_alu.v.
It also consits of a dump.vcd file to visualize the output.

## Operations performed

 + Add
 + Subtract
 + Logical left shift
 + Logicsl right shift
 + AND gate
 + OR gate
 + XOR gate
 + NAND gate

*The addition and subtraction operations are performed using Full Adder Module.*
*The left and right shift operations could be done using a Barrel Shifter Module, but is done usinsg the '<<' and '>>' operators due to time constraint.*

 ## Software Used
 + iVerilog
 + GTKWave

 ## Execution commands
 1. iverilog -o aout alu.v tb_alu.v
 2. vvp aout
 3. gtkwave dump.vcd
