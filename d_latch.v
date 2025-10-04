//=====================================================
// File: d_latch.v
// Author: Monika
// Description: D Latch with asynchronous reset
//=====================================================

module d_latch(d, enable, reset, q, qbar);
  input d, enable, reset;
  output reg q;
  output qbar;
  assign qbar = ~q;

  always @(d or enable or reset) begin
    if (reset)
      q <= 1'b0;
    else if (enable)
      q <= d;
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg d, enable, reset;
  wire q, qbar;

  d_latch uut(d, enable, reset, q, qbar);

  initial begin
     $dumpfile("d_latch.vcd"); // waveform file name
     $dumpvars(0, uut);           // dump all signals of the module instance
  end


  initial begin
    $display("Time | En D Q Qbar");
    $display("------------------");
    enable = 0; reset = 1; d = 0;
    #2 reset = 0; enable = 1; d = 1;
    #5 d = 0;
    #5 enable = 0;
    #5 enable = 1; d = 1;
    #5 d = 0;
    #10 $finish;
  end

  always @(d or enable)
    $display("%4t | %b %b %b %b", $time, enable, d, q, qbar);
endmodule
