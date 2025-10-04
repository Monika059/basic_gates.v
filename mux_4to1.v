//=====================================================
// File: mux_4to1.v
// Author: Monika
// Description: 4:1 Multiplexer (Structural)
//=====================================================

module mux_4to1(a, sel, y);
  input [3:0] a;
  input [1:0] sel;
  output y;
  wire s0n, s1n, w0, w1, w2, w3;

  not (s1n, sel[1]);
  not (s0n, sel[0]);

  and (w0, a[0], s1n, s0n);
  and (w1, a[1], s1n, sel[0]);
  and (w2, a[2], sel[1], s0n);
  and (w3, a[3], sel[1], sel[0]);

  or  (y, w0, w1, w2, w3);
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg [3:0] a;
  reg [1:0] sel;
  wire y;
  mux_4to1 uut(a, sel, y);

  initial begin
    $dumpfile("mux_4to1.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Sel | A[3:0] | Y");
    $display("-----------------");
    for (integer s = 0; s < 4; s = s + 1)
      for (integer i = 0; i < 16; i = i + 1) begin
        a = i; sel = s;
        #1 $display(" %b  | %4b | %b", sel, a, y);
      end
  end
endmodule
