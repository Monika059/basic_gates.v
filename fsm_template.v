//=====================================================
// File: fsm_template.v
// Author: Monika
// Description: Simple 2-State FSM Template
//=====================================================

module fsm_template(clk, reset, in, out);
  input clk, reset, in;
  output reg out;

  // state encoding
  parameter S0 = 1'b0, S1 = 1'b1;
  reg state, next_state;

  // next state logic
  always @(*) begin
    case(state)
      S0: next_state = in ? S1 : S0;
      S1: next_state = in ? S0 : S1;
      default: next_state = S0;
    endcase
  end

  // state update
  always @(posedge clk or posedge reset) begin
    if(reset)
      state <= S0;
    else
      state <= next_state;
  end

  // output logic
  always @(*) begin
    case(state)
      S0: out = 0;
      S1: out = 1;
    endcase
  end
endmodule

//=====================================================
// Testbench
//=====================================================

module testbench;
  reg clk, reset, in;
  wire out;
  fsm_template uut(clk, reset, in, out);

  initial begin
    $dumpfile("fsm_template.vcd"); // waveform file name
    $dumpvars(0, uut);           // dump all signals of the module instance
  end

  initial begin
    $display("Time | In State Out");
    $display("-------------------");
    clk = 0; reset = 1; in = 0;
    #2 reset = 0;
    #5 in = 1;
    #10 in = 0;
    #10 in = 1;
    #10 $finish;
  end

  always #5 clk = ~clk;

  always @(posedge clk)
    $display("%4t |  %b   %b   %b", $time, in, uut.state, out);
endmodule
