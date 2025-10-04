//=====================================================
// File: t_flipflop.v
// Author: Monika
// Description: T Flip-Flop with async reset
//=====================================================

module t_flipflop(clk, reset, T, Q, Qbar);
  input clk, reset, T;
  output reg Q;
  output Qbar;
  assign Qbar = ~Q;

  always @(posedge clk or posedge reset) begin
    if (reset)
      Q <= 1'b0;
    else if (T)
      Q <= ~Q;  // toggle
    else
      Q <= Q;   // no change
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset, T;
  wire Q, Qbar;

  t_flipflop uut(clk, reset, T, Q, Qbar);

  initial begin
    $dumpfile("t_flipflop.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Time | T Q Qbar");
    $display("----------------");
    clk = 0; reset = 1; T = 0;
    #2 reset = 0; T = 1;
    #10 T = 0;
    #10 T = 1;
    #10 T = 1;
    #10 $finish;
  end

  always #5 clk = ~clk;

  always @(posedge clk)
    $display("%4t | %b %b %b", $time, T, Q, Qbar);
endmodule
