//=====================================================
// File: mux_2to1.v
// Author: Monika
// Description: 2:1 Multiplexer (Structural)
//=====================================================

module mux_2to1(a, b, sel, y);
  input a, b, sel;
  output y;
  wire nsel, w1, w2;

  not (nsel, sel);
  and (w1, a, nsel);
  and (w2, b, sel);
  or  (y, w1, w2);
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg a, b, sel;
  wire y;
  mux_2to1 uut(a, b, sel, y);

  initial begin
    $dumpfile("mux_2to1.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Sel | A B | Y");
    $display("------------");
    for (integer i = 0; i < 2; i = i + 1)
      for (integer j = 0; j < 2; j = j + 1)
        for (integer s = 0; s < 2; s = s + 1) begin
          a = i; b = j; sel = s;
          #1 $display(" %b  | %b %b | %b", sel, a, b, y);
        end
  end
endmodule
