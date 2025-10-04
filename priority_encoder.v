//=====================================================
// File: priority_encoder.v
// Author: Monika
// Description: 4-to-2 Priority Encoder (Structural)
//=====================================================

module priority_encoder(D, Y, valid);
  input [3:0] D;
  output [1:0] Y;
  output valid;
  wire n3, n2, n1;

  assign valid = |D; // high if any input is 1

  assign Y[1] = D[3] | D[2];
  assign Y[0] = D[3] | D[1];
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg [3:0] D;
  wire [1:0] Y;
  wire valid;

  priority_encoder uut(D, Y, valid);

  initial begin
    $dumpfile("priority_encoder.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("D3 D2 D1 D0 | Y1 Y0 Valid");
    $display("-------------------------");
    for (integer i = 0; i < 16; i = i + 1) begin
      D = i;
      #1 $display("%b %b %b %b | %b  %b   %b", D[3], D[2], D[1], D[0], Y[1], Y[0], valid);
    end
  end
endmodule
