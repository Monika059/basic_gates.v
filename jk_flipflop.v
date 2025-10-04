//=====================================================
// File: jk_flipflop.v
// Author: Monika
// Description: JK Flip-Flop with async reset
//=====================================================

module jk_flipflop(clk, reset, J, K, Q, Qbar);
  input clk, reset, J, K;
  output reg Q;
  output Qbar;
  assign Qbar = ~Q;

  always @(posedge clk or posedge reset) begin
    if(reset)
      Q <= 1'b0;
    else begin
      case({J,K})
        2'b00: Q <= Q;       // no change
        2'b01: Q <= 1'b0;    // reset
        2'b10: Q <= 1'b1;    // set
        2'b11: Q <= ~Q;      // toggle
      endcase
    end
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset, J, K;
  wire Q, Qbar;

  jk_flipflop uut(clk, reset, J, K, Q, Qbar);

  initial begin
    $dumpfile("jk_flipflop.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Time | J K | Q Qbar");
    $display("-------------------");
    clk = 0; reset = 1; J = 0; K = 0;
    #2 reset = 0;
    #5 J=1; K=0;
    #10 J=0; K=1;
    #10 J=1; K=1;
    #10 J=0; K=0;
    #10 $finish;
  end

  always #5 clk = ~clk;

  always @(posedge clk)
    $display("%4t | %b %b | %b  %b", $time, J, K, Q, Qbar);
endmodule
