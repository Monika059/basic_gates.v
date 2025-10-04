//=====================================================
// File: counter_4bit.v
// Author: Monika
// Description: 4-bit Synchronous Up Counter
//=====================================================

module counter_4bit(clk, reset, count);
  input clk, reset;
  output reg [3:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset)
      count <= 4'b0000;
    else
      count <= count + 1'b1;
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset;
  wire [3:0] count;

  counter_4bit uut(clk, reset, count);

  // waveform generation
  initial begin
    $dumpfile("counter_4bit.vcd"); 
    $dumpvars(0, uut);
  end

  initial begin
    $display("Time | Count");
    $display("------------");
    clk = 0; reset = 1;
    #2 reset = 0;
    #100 $finish;
  end

  always #5 clk = ~clk; // clock generation

  always @(posedge clk)
    $display("%4t | %4b", $time, count);
endmodule
