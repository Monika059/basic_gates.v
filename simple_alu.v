//=====================================================
// File: simple_alu.v
// Author: Monika
// Description: 4-bit Simple ALU with Ripple Carry Adder
//=====================================================

module full_adder(a, b, cin, sum, cout);
  input a, b, cin;
  output sum, cout;
  wire s1, c1, c2;

  xor (s1, a, b);
  xor (sum, s1, cin);
  and (c1, a, b);
  and (c2, s1, cin);
  or  (cout, c1, c2);
endmodule

//=====================================================

module ripple_adder_4bit(a, b, cin, sum, cout);
  input [3:0] a, b;
  input cin;
  output [3:0] sum;
  output cout;
  wire c1, c2, c3;

  full_adder fa0(a[0], b[0], cin,  sum[0], c1);
  full_adder fa1(a[1], b[1], c1,   sum[1], c2);
  full_adder fa2(a[2], b[2], c2,   sum[2], c3);
  full_adder fa3(a[3], b[3], c3,   sum[3], cout);
endmodule

//=====================================================

module simple_alu(a, b, sel, result, cout);
  input [3:0] a, b;
  input [2:0] sel;
  output reg [3:0] result;
  output reg cout;

  wire [3:0] sum, diff;
  wire c_add, c_sub;

  // addition
  ripple_adder_4bit adder(a, b, 1'b0, sum, c_add);

  // subtraction (a + ~b + 1)
  ripple_adder_4bit subtractor(a, ~b, 1'b1, diff, c_sub);

  always @(*) begin
    case (sel)
      3'b000: begin result = sum; cout = c_add; end   // ADD
      3'b001: begin result = diff; cout = c_sub; end  // SUB
      3'b010: begin result = a & b; cout = 0; end     // AND
      3'b011: begin result = a | b; cout = 0; end     // OR
      3'b100: begin result = a ^ b; cout = 0; end     // XOR
      default: begin result = 4'b0000; cout = 0; end
    endcase
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg [3:0] a, b;
  reg [2:0] sel;
  wire [3:0] result;
  wire cout;

  simple_alu uut(a, b, sel, result, cout);

  initial begin
     $dumpfile("simple_alu.vcd"); // waveform file name
     $dumpvars(0, uut);           // dump all signals of the module instance
  end


  initial begin
    $display(" A     B     Sel | Result Cout | Operation");
    $display("------------------------------------------");
    for (integer s = 0; s < 5; s = s + 1) begin
      a = 4'b1010; b = 4'b0101; sel = s;
      #1 case (sel)
        3'b000: $display("%4b %4b  %3b  |  %4b    %b   | ADD", a, b, sel, result, cout);
        3'b001: $display("%4b %4b  %3b  |  %4b    %b   | SUB", a, b, sel, result, cout);
        3'b010: $display("%4b %4b  %3b  |  %4b    %b   | AND", a, b, sel, result, cout);
        3'b011: $display("%4b %4b  %3b  |  %4b    %b   | OR ", a, b, sel, result, cout);
        3'b100: $display("%4b %4b  %3b  |  %4b    %b   | XOR", a, b, sel, result, cout);
      endcase
    end
  end
endmodule
