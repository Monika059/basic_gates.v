//=====================================================
// File: decoder_1to4.v
// Author: Monika
// Description: 1-to-4 Decoder with enable
//=====================================================

module decoder_1to4(a, en, y);
  input a, en;
  output [3:0] y;
  wire na;

  not (na, a);
  and (y[0], na, en);
  and (y[1], a, en);
  and (y[2], 1'b0, en); // unused, can keep 0
  and (y[3], 1'b0, en); // unused, can keep 0
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg a, en;
  wire [3:0] y;

  decoder_1to4 uut(a, en, y);

  initial begin
    $dumpfile("decoder_1to4.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end


  initial begin
    $display("A En | Y3 Y2 Y1 Y0");
    $display("-----------------");
    en = 1;
    for (integer i = 0; i < 2; i = i + 1) begin
      a = i;
      #1 $display("%b  %b | %b  %b  %b  %b", a, en, y[3], y[2], y[1], y[0]);
    end
  end
endmodule
