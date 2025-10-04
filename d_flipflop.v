//=====================================================
// File: d_flipflop.v
// Author: Monika
// Description: D Flip-Flop with async reset
//=====================================================

module d_flipflop(clk, reset, d, q, qbar);
  input clk, reset, d;
  output reg q;
  output qbar;
  assign qbar = ~q;

  always @(posedge clk or posedge reset) begin
    if (reset)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset, d;
  wire q, qbar;

  d_flipflop uut(clk, reset, d, q, qbar);

  initial begin
     $dumpfile("d_flipflop.vcd"); // waveform file name
     $dumpvars(0, uut);           // dump all signals of the module instance
  end


  initial begin
    $display("Time | D Q Qbar");
    $display("----------------");
    clk = 0; reset = 1; d = 0;
    #2 reset = 0;
    #2 d = 1;
    #20 d = 0;
    #10 d = 1;
    #20 $finish;
  end

  always #5 clk = ~clk; // clock generation

  always @(posedge clk)
    $display("%4t | %b %b %b", $time, d, q, qbar);
endmodule
