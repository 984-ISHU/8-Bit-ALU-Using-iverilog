// Testbench for ALU module
module alu_tb();
  reg [2:0] opcode;
  reg [7:0] OperandA, OperandB;
  wire [7:0] result;

  // Instantiate ALU module
  alu uut(
    .opcode(opcode),
    .OperandA(OperandA),
    .OperandB(OperandB),
    .result(result)
  );

  integer i;

  // Test cases
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, alu_tb);
  end

  initial begin
    OperandA = 50; OperandB = 10; opcode = 3'b000;

    for (i = 1; i < 8; i = i + 1) begin
      #10
      opcode = i;
    end

    #10
    $finish();
  end

endmodule
