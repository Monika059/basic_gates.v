//=====================================================
// File: sr_latch.v
// Author: Monika
// Description: SR Latch (Level-Sensitive, Structural)
//=====================================================

module sr_latch(S, R, Q, Qbar);
  input S, R;
  output Q, Qbar;
  wire n1, n2;

  nor (Q, R, Qbar);
  nor (Qbar, S, Q);
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg S, R;
  wire Q, Qbar;
  sr_latch uut(S, R, Q, Qbar);

  initial begin
    $dumpfile("sr_latch.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("S R | Q Qbar");
    $display("------------");
    S = 0; R = 0; #1 $display("%b %b | %b %b", S, R, Q, Qbar);
    S = 0; R = 1; #1 $display("%b %b | %b %b", S, R, Q, Qbar);
    S = 1; R = 0; #1 $display("%b %b | %b %b", S, R, Q, Qbar);
    S = 1; R = 1; #1 $display("%b %b | %b %b", S, R, Q, Qbar);
  end
endmodule
