// Inverter module
module invert(input wire [7:0] i, output wire [7:0] o);
   assign o = ~i;
endmodule

module and2 (input wire [7:0] i0, i1, output wire [7:0] o);
  assign o = i0 & i1;
endmodule

module xor2 (input wire [7:0] i0, i1, output wire [7:0] o);
  assign o = i0 ^ i1;
endmodule

module or2 (input wire [7:0] i0, i1, output wire [7:0] o);
  assign o = i0 | i1;
endmodule


module nand2 (input wire [7:0] i0, i1, output wire [7:0] o);
   wire [7:0] t;
   and2 and2_0 (.i0(i0), .i1(i1), .o(t));
   invert invert_0 (.i(t), .o(o));
endmodule

module lls (input wire [7:0] i0, output wire [7:0] o);
    assign o = i0 << 1;
endmodule

module lrs (input wire [7:0] i0, output wire [7:0] o);
    assign o = i0 >> 1;  
endmodule

// Full Adder module
module full_adder(
    output cout,
    output sum,
    input ain,
    input bin,
    input cin
    );

    //assign bin2 = cin^bin; // XORing the inputs to bin with cin. If 1, subtract; if 0, add
    
    assign sum = ain^bin^cin;
    assign cout = (ain&bin) | (ain&cin) | (bin&cin);
endmodule

module adder8(
    output cout, //MSB, determines if answer is positive or negative
    output [7:0] s,
    input [7:0] a,
    input [7:0] b,
    input cin // if 1, subtract, if 0, add. This is XOR'ed with b
    );
    
    wire [7:0] bin;
    assign bin[0] = b[0]^cin;
    assign bin[1] = b[1]^cin;
    assign bin[2] = b[2]^cin;
    assign bin[3] = b[3]^cin;
    assign bin[4] = b[4]^cin;                          
    assign bin[5] = b[5]^cin;
    assign bin[6] = b[6]^cin;
    assign bin[7] = b[7]^cin;
    
      
    wire [8:1] carry; 
     full_adder FA0(carry[1],s[0],a[0],bin[0],cin);
     full_adder FA1(carry[2],s[1],a[1],bin[1],carry[1]);
     full_adder FA2(carry[3],s[2],a[2],bin[2],carry[2]);
     full_adder FA3(carry[4],s[3],a[3],bin[3],carry[3]);
     full_adder FA4(carry[5],s[4],a[4],bin[4],carry[4]);
     full_adder FA5(carry[6],s[5],a[5],bin[5],carry[5]);
     full_adder FA6(carry[7],s[6],a[6],bin[6],carry[6]);
     full_adder FA7(carry[8],s[7],a[7],bin[7],carry[7]);
     
     assign cout = cin^carry[8];
   
endmodule

module alu(
  input wire [2:0] opcode,
  input wire [7:0] OperandA, OperandB,
  output reg [7:0] result
);

  wire [7:0] and_result, or_result, xor_result, nand_result, lls_result, lrs_result, negated_B, adder_sum, sub_sum;
  wire adder_cout, sub_cout;

  // Inverter for negating OperandB

  // Instantiate a full adder for addition
  adder8 adder_inst(.a(OperandA), .b(OperandB), .cin(1'b0), .s(adder_sum), .cout(adder_cout));
  adder8 sub_inst(.a(OperandA), .b(OperandB), .cin(1'b1), .s(sub_sum), .cout(sub_cout));
  and2 and_inst(.i0(OperandA), .i1(OperandB), .o(and_result));
  or2 or_inst(.i0(OperandA), .i1(OperandB), .o(or_result));
  xor2 xor_inst(.i0(OperandA), .i1(OperandB), .o(xor_result)); // Corrected instantiation for xor2
  nand2 nand_inst(.i0(OperandA), .i1(OperandB), .o(nand_result));
  lls lls_inst(.i0(OperandA), .o(lls_result));
  lrs lrs_inst(.i0(OperandA), .o(lrs_result));

  always @(*) begin
    case (opcode)
      3'b000: result = adder_sum[7:0];  // Output only the lower 8 bits for addition
      3'b001: result = sub_sum[7:0];  // Subtraction using full adder
      3'b010: result = lls_result; // Logical left shift
      3'b011: result = lrs_result; // Logical right shift
      3'b100: result = and_result; // AND
      3'b101: result = or_result; // OR
      3'b110: result = xor_result; // XOR
      3'b111: result = nand_result; // NAND
      default: result = 8'b0;
    endcase
  end

endmodule

