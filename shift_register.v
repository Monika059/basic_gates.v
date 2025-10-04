//=====================================================
// File: shift_register.v
// Author: Monika
// Description: 4-bit Shift Register (Left/Right Shift)
//=====================================================

module shift_register(clk, reset, serial_in, shift_en, dir, q);
  input clk, reset, serial_in, shift_en, dir;
  output reg [3:0] q;

  always @(posedge clk or posedge reset) begin
    if(reset)
      q <= 4'b0000;
    else if(shift_en) begin
      if(dir)       // shift left
        q <= {q[2:0], serial_in};
      else          // shift right
        q <= {serial_in, q[3:1]};
    end
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset, serial_in, shift_en, dir;
  wire [3:0] q;

  shift_register uut(clk, reset, serial_in, shift_en, dir, q);

  initial begin
    $dumpfile("shift_register.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Time | Dir Shift_in | Q");
    $display("------------------------");
    clk = 0; reset = 1; serial_in = 0; shift_en = 1; dir = 1;
    #2 reset = 0;
    #5 serial_in = 1;
    #10 dir = 0; serial_in = 0;
    #10 serial_in = 1;
    #10 $finish;
  end

  always #5 clk = ~clk;

  always @(posedge clk)
    $display("%4t |  %b   %b        | %4b", $time, dir, serial_in, q);
endmodule
