//=====================================================
// File: updown_counter.v
// Author: Monika
// Description: 4-bit Synchronous Up/Down Counter
//=====================================================

module updown_counter(clk, reset, up_down, count);
  input clk, reset, up_down;
  output reg [3:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset)
      count <= 4'b0000;
    else if (up_down)
      count <= count + 1'b1;   // Count Up
    else
      count <= count - 1'b1;   // Count Down
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset, up_down;
  wire [3:0] count;

  updown_counter uut(clk, reset, up_down, count);


  initial begin
    $dumpfile("updown_counter.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Time | Up_Dn | Count");
    $display("--------------------");
    clk = 0; reset = 1; up_down = 1;
    #2 reset = 0;
    #40 up_down = 0; // switch to down count
    #40 $finish;
  end

  always #5 clk = ~clk; // clock generation

  always @(posedge clk)
    $display("%4t |   %b   | %4b", $time, up_down, count);
endmodule
