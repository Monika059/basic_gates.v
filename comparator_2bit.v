//=====================================================
// File: comparator_2bit.v
// Author: Monika
// Description: 2-bit Comparator (Structural Verilog)
//=====================================================

module comparator_2bit(a, b, eq, gt, lt);
  input [1:0] a, b;
  output eq, gt, lt;

  wire x0, x1, n0, n1, g1, l1;

  // bitwise equality
  xor (x0, a[0], b[0]);
  xor (x1, a[1], b[1]);
  nor (eq, x0, x1);

  // greater than logic
  and (g1, a[1], ~b[1]);
  and (g0, eq, a[0], ~b[0]);
  or  (gt, g1, g0);

  // less than logic
  and (l1, ~a[1], b[1]);
  and (l0, eq, ~a[0], b[0]);
  or  (lt, l1, l0);
endmodule

//=====================================================
// Testbench
//=====================================================
module testbench;
  reg [1:0] a, b;
  wire eq, gt, lt;
  comparator_2bit uut(a, b, eq, gt, lt);

  initial begin
    $dumpfile("comparator_2bit.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end


  initial begin
    $display("A  B | EQ GT LT");
    $display("-------------");
    for (integer i = 0; i < 4; i = i + 1)
      for (integer j = 0; j < 4; j = j + 1) begin
        a = i; b = j;
        #1 $display("%b %b |  %b  %b  %b", a, b, eq, gt, lt);
      end
  end
endmodule
